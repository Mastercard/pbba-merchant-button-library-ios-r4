//
//  PBBACertificateTrustService.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/25/17.
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

#import "PBBACertificateTrustService.h"

#import "NSError+PBBAUtils.h"
#import "NSString+PBBAUtils.h"

static NSString * const pemPrefix = @"-----BEGIN CERTIFICATE-----";
static NSString * const pemSuffix = @"-----END CERTIFICATE-----";

@implementation PBBACertificateTrustService

- (NSArray<NSData *> *)derCertificateChainForPEMChain:(NSString *)pemChain
{
    if (!pemChain) {
        return nil;
    }
    
    NSString *chain = pemChain;
    NSMutableArray *certificates = [NSMutableArray array];
    
    // Parse the PEM chain
    NSRange range = [chain rangeOfString:pemSuffix];;
    while (range.location != NSNotFound) {
        NSString *certificate = [chain substringToIndex:(range.location + range.length)];
        certificate = [certificate pbba_trim];
        
        // Parse the PEM certificate
        NSData *certificateData = [self derCertificateForPEMCertificate:certificate];
        if (!certificateData) {
            return nil;
        }
        
        [certificates addObject:certificateData];
        
        chain = [chain substringFromIndex:(range.location + range.length + 1)];
        range = [chain rangeOfString:pemSuffix];
    }
    
    // Check if there are no invalid characters left after parsing the chain
    chain = [chain pbba_trim];
    if (chain.length) {
        return nil;
    }
    
    return (certificates.count) ? [certificates copy] : nil;
}

- (NSData *)derCertificateForPEMCertificate:(NSString *)pemCertificate
{
    if (!pemCertificate) {
        return nil;
    }
    
    NSString *certificate = pemCertificate;
    if ([certificate hasPrefix:pemPrefix] && [certificate hasSuffix:pemSuffix]) {
        certificate = [certificate stringByReplacingOccurrencesOfString:pemPrefix withString:@""];
        certificate = [certificate stringByReplacingOccurrencesOfString:pemSuffix withString:@""];
    }
    
    return [[NSData alloc] initWithBase64EncodedString:certificate options:NSDataBase64DecodingIgnoreUnknownCharacters];;
}

- (SecKeyRef)getPublicKeyAfterEvaluatingTrust:(NSArray<NSData *> *)certificateChainData
                           anchorCertificates:(NSArray<NSData *> *)anchorCertificatesData
                             validCommonNames:(NSArray<NSString *> *)validCommonNames
                                        error:(NSError *__autoreleasing *)error
{
    NSArray *certificates = [self mapCertificatesDataToSecCertificateRefs:certificateChainData];
    
    if (!certificates.count) {
        PBBA_ERROR(error, [NSError pbba_invalidPublicKeyCertificateErrorWithDetails:@"The certificate chain is missing."]);
        return NULL;
    }
    
    // Check leaf certificate common name
    NSString *certificateCommonName = [self commonNameForCertificate:(__bridge SecCertificateRef)(certificates.firstObject)];
    if (certificateCommonName) {
        BOOL valid = NO;
        for (NSString *validCommonName in validCommonNames) {
            if ([[validCommonName pbba_trim] isEqualToString:certificateCommonName]) {
                valid = YES;
                break;
            }
        }
        
        if (!valid) {
            if (error) {
                NSString *errorDetailsFormat =
                    @"Certificate Common Name: %@, doesn't match the whitelisted values: %@";
                NSString *errorDetails =
                    [NSString stringWithFormat:errorDetailsFormat, certificateCommonName, validCommonNames];
                *error = [NSError pbba_invalidPublicKeyCertificateErrorWithDetails:errorDetails];
            }
            
            return NULL;
        }
    }
    
    // Check certificate chain trust
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    
    SecTrustRef trustRef = NULL;
    SecKeyRef publicKeyRef = NULL;
    
    if (SecTrustCreateWithCertificates((__bridge CFTypeRef) certificates, policyRef, &trustRef) == noErr) {
        // Set trusted anchor certificate
        SecTrustSetAnchorCertificatesOnly(trustRef, YES);
        [self setTrustedAnchorCertificates:anchorCertificatesData trust:trustRef];
        
        // Evaluate the chain trust
        if ([self evaluateTrust:trustRef error:error]) {
            publicKeyRef = SecTrustCopyPublicKey(trustRef);
        }
    }
    
    // Cleanup
    if (trustRef) CFRelease(trustRef);
    if (policyRef) CFRelease(policyRef);
    
    return publicKeyRef ? (SecKeyRef) CFAutorelease(publicKeyRef) : NULL;
}

- (BOOL)setTrustedAnchorCertificates:(NSArray<NSData *> *)certificatesData
                               trust:(SecTrustRef)trustRef
{
    if (!certificatesData.count || !trustRef)
        return NO;
    
    NSArray *anchorCertificates = [self mapCertificatesDataToSecCertificateRefs:certificatesData];
    if (anchorCertificates) {
        OSStatus status = SecTrustSetAnchorCertificates(trustRef, (__bridge CFTypeRef) anchorCertificates);
        
        return status == errSecSuccess;
    }
    
    return NO;
}

- (BOOL)evaluateTrust:(SecTrustRef)trustRef
                error:(NSError *__autoreleasing *)error
{
    BOOL trusted = NO;
    
    SecTrustResultType trustResult;
    SecTrustEvaluate(trustRef, &trustResult);
    trusted = ((trustResult == kSecTrustResultProceed) ||
               (trustResult == kSecTrustResultUnspecified));
    
    // Collect error details
    if (!trusted && error != NULL) {
        NSArray *failureDetails = (NSArray *) CFBridgingRelease(SecTrustCopyProperties(trustRef));
        *error = [NSError pbba_invalidPublicKeyCertificateErrorWithDetails:failureDetails.description];
    }
    
    return trusted;
}

- (NSString *)commonNameForCertificate:(SecCertificateRef)certificateRef
{
    if (certificateRef) {
        CFStringRef commonNameRef = NULL;
        
        // Check if function is available (iOS 10.3 and above)
        if (SecCertificateCopyCommonName) {
            SecCertificateCopyCommonName(certificateRef, &commonNameRef);
        }
        
        if (commonNameRef) {
            return CFBridgingRelease(commonNameRef);
        }
    }
    
    return nil;
}

- (NSArray *)mapCertificatesDataToSecCertificateRefs:(NSArray<NSData *> *)certificatesData
{
    // Map certificate data to SecCertificateRef
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:certificatesData.count];
    for (NSData *certificateData in certificatesData) {
        SecCertificateRef certificateRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) certificateData);
        if (!certificateRef)
            return nil;
        
        [certificates addObject:(__bridge id) certificateRef];
        CFRelease(certificateRef);
    }
    
    return [certificates copy];
}

@end
