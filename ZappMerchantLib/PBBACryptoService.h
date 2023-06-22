//
//  PBBACryptoService.h
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

#import <Foundation/Foundation.h>

/**
 Service class for cryptographic operations.
 */
@interface PBBACryptoService : NSObject

/**
 The URL safe base64 encoded SHA-256 digest for input data.

 @param data The input data.
 
 @return The URL safe base64 encoded SHA-256 digest.
 */
- (NSString *)sha256:(NSData *)data;

/**
 Verify the JWS signing input for given RS256 signature and X.509 public key certificate data.
 
 @param signingInput The JWS signing input.
 @param signature The JWS signature.
 @param certificateChain The list (chain) of X.509 public key certificate data to be used for signature decryption.
 @param anchorCertificatesData The list of trusted anchor certificate data to be used for trust evaluation.
 @param validCommonNames The list of the valid certificate common names used for trust evaluation.
 @param error The signature validation error.
 
 @return YES if the signature was verified with success.
 */
- (BOOL)verifySigningInput:(NSString *)signingInput
                 signature:(NSData *)signature
          certificateChain:(NSArray<NSData *> *)certificateChain
        anchorCertificates:(NSArray<NSData *> *)anchorCertificatesData
          validCommonNames:(NSArray<NSString *> *)validCommonNames
                     error:(NSError *__autoreleasing *)error;

@end
