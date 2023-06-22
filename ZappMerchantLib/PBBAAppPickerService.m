//
//  PBBAAppPickerService.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/11/17.
//  Copyright 2017 Vocalink Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

#import "PBBAAppPickerService.h"
#import "PBBAAppPickerConfiguration.h"
#import "PBBAJSONWebSignatureService.h"
#import "PBBACryptoService.h"
#import "PBBACertificateTrustService.h"
#import "PBBAAppPickerUtils.h"

#import "NSError+PBBAUtils.h"

typedef void (^PBBAPublicKeyCertificateCompletionHandler)(NSData *certificateData, NSError *error);

typedef void (^PBBADataTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);
typedef void (^PBBADownloadTaskCompletionHandler)(NSURL *location, NSURLResponse *response, NSError *error);

static NSTimeInterval const kAppPickerManifestRequestTimeout = 10;


@interface PBBAURLSessionDelegate : NSObject <NSURLSessionDelegate>

@end

@implementation PBBAURLSessionDelegate

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        BOOL trusted = NO;
        
        PBBACertificateTrustService *certificateTrustService = [PBBACertificateTrustService new];
        
//#ifdef DEBUG
//        // Trust self-signed certificate for debug
//        NSData *debugAnchorTLSCertificateData = [PBBAAppPickerConfiguration debugAnchorTLSCertificate];
//        if (debugAnchorTLSCertificateData) {
//            [certificateTrustService setTrustedAnchorCertificates:@[debugAnchorTLSCertificateData]
//                                                            trust:challenge.protectionSpace.serverTrust];
//        }
//#endif
        
        NSURL *appPickerManifestURL = [PBBAAppPickerConfiguration appPickerManifestURL];
        if ([challenge.protectionSpace.host isEqualToString:appPickerManifestURL.host]) {
            trusted = [certificateTrustService evaluateTrust:challenge.protectionSpace.serverTrust error:nil];
        }
        
        if (trusted) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
        
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end


@interface PBBAAppPickerService ()

@property (nonatomic, strong) NSURLSession *appPickerManifestURLSession;
@property (nonatomic, strong) NSURLSession *appIconURLSession;

@property (nonatomic, strong) NSMutableDictionary<NSURL *, UIImage *> *appIconsCache;

@end

@implementation PBBAAppPickerService

- (void)dealloc
{
    // Invalidate all the sessions
    [self.appPickerManifestURLSession invalidateAndCancel];
    [self.appIconURLSession invalidateAndCancel];
}

- (NSURLSession *)appPickerManifestURLSession
{
    if (_appPickerManifestURLSession == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        configuration.timeoutIntervalForRequest = kAppPickerManifestRequestTimeout;
        configuration.TLSMinimumSupportedProtocol = kTLSProtocol12;
        PBBAURLSessionDelegate *sessionDelegate = [PBBAURLSessionDelegate new];
        _appPickerManifestURLSession = [NSURLSession sessionWithConfiguration:configuration
                                                                     delegate:sessionDelegate
                                                                delegateQueue:nil];
    }
    
    return _appPickerManifestURLSession;
}

- (NSURLSession *)appIconURLSession
{
    if (_appIconURLSession == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        configuration.TLSMinimumSupportedProtocol = kTLSProtocol12;
        _appIconURLSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    
    return _appIconURLSession;
}

- (NSMutableDictionary<NSURL *, UIImage *> *)appIconsCache
{
    if (_appIconsCache == nil) {
        _appIconsCache = [NSMutableDictionary dictionary];
    }
    
    return _appIconsCache;
}

#pragma mark - Retrieve App Picker Manifest

- (void)getAppPickerItems:(PBBAAppPickerItemsCompletionHandler)completion
{
    NSDictionary *cache = [self loadCache];
    if (cache) {
        [self processPayload:cache completion:completion cache:NO];
    } else {
        PBBADataTaskCompletionHandler dataTaskCompletionHandler =
            ^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                
                if (error) {
                    // Network error
                    [self complete:completion items:nil error:error];
                } else if (httpResponse.statusCode != 200 /* OK */) {
                    // Server error
                    [self complete:completion items:nil error:[NSError pbba_unableToRetrieveAppPickerManifestError]];
                } else {
                    // Decode JWS content
                    NSString *jwsInput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    PBBAJSONWebSignatureService *jwsService = [PBBAJSONWebSignatureService new];
                    [jwsService decodeJWS:jwsInput completion:^(NSDictionary *jwsHeader,
                                                                NSDictionary *jwsPayload,
                                                                NSData *jwsSignature,
                                                                NSString *jwsSigningInput,
                                                                NSError *error) {
                        
                        if (error) {
                            [self complete:completion items:nil error:error];
                        } else {
                            [self processDecodedJWSHeader:jwsHeader
                                               jwsPayload:jwsPayload
                                             jwsSignature:jwsSignature
                                          jwsSigningInput:jwsSigningInput
                                               completion:completion];
                        }
                    }];
                }
            };
        
        NSURL *appPickerManifestURL = [PBBAAppPickerConfiguration appPickerManifestURL];
        NSURLSessionDataTask *task =
            [self.appPickerManifestURLSession dataTaskWithURL:appPickerManifestURL
                                            completionHandler:dataTaskCompletionHandler];
        
        [task resume];
    }
}

- (void)processDecodedJWSHeader:(NSDictionary *)jwsHeader
                     jwsPayload:(NSDictionary *)jwsPayload
                   jwsSignature:(NSData *)jwsSignature
                jwsSigningInput:(NSString *)jwsSigningInput
                     completion:(PBBAAppPickerItemsCompletionHandler)completion
{
    NSURL *appPickerManifestURL = [PBBAAppPickerConfiguration appPickerManifestURL];
    NSURL *publicKeyCertificateChainURL = [NSURL URLWithString:jwsHeader[@"x5u"]];
    
    // Fail if the public key certificate chain doesn't come from the same host as manifest
    if (![publicKeyCertificateChainURL.host isEqualToString:appPickerManifestURL.host]) {
        [self complete:completion items:nil error:[NSError pbba_unableToDecodeJWSContentError]];
        return;
    }
    
    [self getAppPickerManifestPublicKeyCertificateChain:publicKeyCertificateChainURL
                                             completion:^(NSData *certificateChainData, NSError *error) {
                                                 if (error) {
                                                     [self complete:completion items:nil error:error];
                                                 } else {
                                                     [self processDecodedJWSHeader:jwsHeader
                                                                        jwsPayload:jwsPayload
                                                                      jwsSignature:jwsSignature
                                                                   jwsSigningInput:jwsSigningInput
                                                              certificateChainData:certificateChainData
                                                                        completion:completion];
                                                 }
                                             }];
}

- (void)processDecodedJWSHeader:(NSDictionary *)jwsHeader
                     jwsPayload:(NSDictionary *)jwsPayload
                   jwsSignature:(NSData *)jwsSignature
                jwsSigningInput:(NSString *)jwsSigningInput
           certificateChainData:(NSData *)certificateChainData
                     completion:(PBBAAppPickerItemsCompletionHandler)completion
{
    NSArray<NSData *> *trustedAnchorCertificateData = [PBBAAppPickerConfiguration trustedAnchorCertificates];
    NSArray<NSString *> *validCommonNames = [PBBAAppPickerConfiguration appPickerManifestPublicKeyCertificateCommonNames];
    
    // Convert the PEM chain to a DER chain
    NSString *pemEncodedChain = [[NSString alloc] initWithData:certificateChainData encoding:NSUTF8StringEncoding];
    PBBACertificateTrustService *certificateTrustService = [PBBACertificateTrustService new];
    NSArray<NSData *> *derEncodedChain = [certificateTrustService derCertificateChainForPEMChain:pemEncodedChain];
    
    // Verify app picker manifest digital signature
    PBBACryptoService *cryptoService = [PBBACryptoService new];
    NSError *signatureVerificationError;
    BOOL valid = [cryptoService verifySigningInput:jwsSigningInput
                                         signature:jwsSignature
                                  certificateChain:derEncodedChain
                                anchorCertificates:trustedAnchorCertificateData
                                  validCommonNames:validCommonNames
                                             error:&signatureVerificationError];
    
    if (valid) {
        [self processPayload:jwsPayload completion:completion cache:YES];
    } else {
        [self complete:completion items:nil error:signatureVerificationError];
    }
}

- (void)processPayload:(NSDictionary *)jwsPayload
            completion:(PBBAAppPickerItemsCompletionHandler)completion
                 cache:(BOOL)cache
{
    // Map app picker manifest JSON to app picker items
    NSError *mappingError;
    NSArray<PBBAAppPickerItem *> *items = [self mapJSONDataToAppPickerItems:jwsPayload error:&mappingError];
    
    if (!mappingError && cache) {
        // Cache payload
        [self persistCache:jwsPayload];
    }
    
    [self complete:completion items:items error:mappingError];
}

- (void)getAppPickerManifestPublicKeyCertificateChain:(NSURL *)url
                                           completion:(PBBAPublicKeyCertificateCompletionHandler)completion
{
    PBBADownloadTaskCompletionHandler downloadTaskCompletionHandler =
        ^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if (error) {
                // Network error
                completion(nil, error);
            } else if (httpResponse.statusCode != 200 /* OK */) {
                // Server error
                completion(nil, [NSError pbba_unableToRetrievePublicKeyCertificate]);
            } else {
                NSData *certificateData = [NSData dataWithContentsOfURL:location];
                completion(certificateData, nil);
            }
        };
    
    NSURLSessionDownloadTask *task =
    [self.appPickerManifestURLSession downloadTaskWithURL:url
                                        completionHandler:downloadTaskCompletionHandler];
    
    [task resume];
}

- (NSArray<PBBAAppPickerItem *> *)mapJSONDataToAppPickerItems:(NSDictionary *)json
                                                        error:(NSError *__autoreleasing *)error
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:json.count];
    for (NSDictionary *rawItem in json[@"apps"]) {
        PBBAAppPickerItem *item = [[PBBAAppPickerItem alloc] initWithDictionary:rawItem error:error];
        
        // Failed to create the app picker item
        if (!item) {
            return nil;
        }
        
        [items addObject:item];
    }
    
    // Fail if no app picker items found
    if (!items.count) {
        PBBA_ERROR(error, [NSError pbba_invalidAppPickerFormatError]);
        
        return nil;
    }
    
    return [items copy];
}

- (void)complete:(PBBAAppPickerItemsCompletionHandler)completion
           items:(NSArray<PBBAAppPickerItem *> *)items
           error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(items, error);
        }
    });
}

#pragma mark - Retrieve App Icons

- (void)getAppIconWithURL:(NSURL *)url
              appIconHash:(NSString *)appIconHash
               completion:(PBBAAppIconCompletionHandler)completion
{
    UIImage *cachedImage = self.appIconsCache[url];
    if (cachedImage) {
        [self complete:completion appIcon:cachedImage error:nil];
        
        return;
    }
    
    PBBADownloadTaskCompletionHandler downloadTaskCompletionHandler =
        ^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (error) {
                [self complete:completion appIcon:nil error:error];
            } else {
                NSData *rawImage = [NSData dataWithContentsOfURL:location];
                
                // Verify app icon hash
                PBBACryptoService *cryptoService = [PBBACryptoService new];
                NSString *rawImageHash = [cryptoService sha256:rawImage];
                if ([appIconHash isEqualToString:rawImageHash]) {
                    UIImage *appIcon = [UIImage imageWithData:rawImage];
                    self.appIconsCache[url] = appIcon;
                    [self complete:completion
                           appIcon:appIcon
                             error:nil];
                } else {
                    [self complete:completion
                           appIcon:nil
                             error:[NSError pbba_invalidAppIconError]];
                }
            }
        };
    
    NSURLSessionDownloadTask *task =
        [self.appIconURLSession downloadTaskWithURL:url
                                  completionHandler:downloadTaskCompletionHandler];
    
    [task resume];
}

- (void)complete:(PBBAAppIconCompletionHandler)completion
         appIcon:(UIImage *)appIcon
           error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(appIcon, error);
        }
    });
}

#pragma mark - Caching

- (NSString *)cacheFilePath
{
    NSString *cacheDirectoryPath =
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cacheDirectoryPath stringByAppendingPathComponent:@"com.pbba.app.picker.cache"];
}

- (BOOL)persistCache:(NSDictionary *)cache
{
    if (cache) {
        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cache];
        return [cacheData writeToFile:[self cacheFilePath] atomically:YES];
    }
    
    return NO;
}

- (NSDictionary *)loadCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFilePath = [self cacheFilePath];
    NSDictionary *cacheAttributes = [fileManager attributesOfItemAtPath:cacheFilePath error:nil];
    
    if (cacheAttributes) {
        NSDate *cacheCreationDate = [cacheAttributes fileCreationDate];
        NSData *cacheData = [NSData dataWithContentsOfFile:cacheFilePath];
        
        if (cacheData) {
            NSDictionary *cache = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
            NSTimeInterval cacheLifetime = [cache[@"cacheLifetime"] unsignedIntegerValue];
            cacheLifetime *= 3600; // Convert hours to seconds
            
            NSTimeInterval cacheAge = fabs([cacheCreationDate timeIntervalSinceNow]);
            if (cacheAge <= cacheLifetime) {
                return cache;
            } else {
                // Remove expired cache
                [fileManager removeItemAtPath:cacheFilePath error:nil];
            }
        }
    }
    
    return nil; // No cache or cache is expired
}

@end
