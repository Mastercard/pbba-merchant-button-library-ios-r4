//
//  PBBACryptoService.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/29/17.
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

#import <CommonCrypto/CommonDigest.h>

#import "PBBACryptoService.h"
#import "PBBACertificateTrustService.h"

#import "NSString+PBBAUtils.h"
#import "NSError+PBBAUtils.h"

@implementation PBBACryptoService

- (NSString *)sha256:(NSData *)data
{
    if (!data) return nil;
    
    uint8_t hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([data bytes], (CC_LONG) [data length], hash);
    NSData *sha256 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
    
    return [NSString pbba_URLSafeBase64Encode:sha256];
}

- (BOOL)verifySigningInput:(NSString *)signingInput
                 signature:(NSData *)signature
          certificateChain:(NSArray<NSData *> *)certificateChain
        anchorCertificates:(NSArray<NSData *> *)anchorCertificatesData
          validCommonNames:(NSArray<NSString *> *)validCommonNames
                     error:(NSError *__autoreleasing *)error
{
    PBBACertificateTrustService *certificateTrustService = [PBBACertificateTrustService new];
    SecKeyRef publicKey =
        [certificateTrustService getPublicKeyAfterEvaluatingTrust:certificateChain
                                               anchorCertificates:anchorCertificatesData
                                                 validCommonNames:validCommonNames
                                                            error:error];
    
    if (!signingInput || !signature || !publicKey) {
        return NO;
    }
    
    publicKey = (SecKeyRef) CFRetain(publicKey);
    
    NSData *data = [signingInput dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t signedHashSize = SecKeyGetBlockSize(publicKey);
    const void *signedHash = [signature bytes];
    
    size_t hashSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([data bytes], (CC_LONG) [data length], hash);
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hash,
                                      hashSize,
                                      signedHash,
                                      signedHashSize);
    
    CFRelease(publicKey);
    
    BOOL success = (status == errSecSuccess);
    if (!success) {
        PBBA_ERROR(error, [NSError pbba_jwsSignatureVerificationError]);
    }
    
    return success;
}

@end
