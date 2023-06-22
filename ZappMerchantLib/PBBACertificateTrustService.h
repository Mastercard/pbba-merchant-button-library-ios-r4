//
//  PBBACertificateTrustService.h
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

#import <Foundation/Foundation.h>

/**
 Service class for DER encoded X.509 certificate related operations.
 */
@interface PBBACertificateTrustService : NSObject

/**
 Convert a PEM encoded chain of certificates to a DER encoded chain.

 @param pemChain The PEM encoded chain of X.509 certificates.
 
 @return The list (chain) of DER encoded X.509 certificate data.
 */
- (NSArray<NSData *> *)derCertificateChainForPEMChain:(NSString *)pemChain;

/**
 Convert a PEM encoded X.509 certificate to a DER encoded certificate.

 @param pemCertificate The PEM encoded X.509 certificate.
 
 @return The DER encoded X.509 certificate data.
 */
- (NSData *)derCertificateForPEMCertificate:(NSString *)pemCertificate;

/**
 Get RSA public key from DER encoded X.509 certificate data after evaluating its trust.
 
 @param certificateChainData The list (chain) of DER encoded X.509 certificate data.
 @param anchorCertificatesData The trusted list of anchor certificates data.
 @param validCommonNames The list of the valid certificate common names used for trust evaluation.
 @param error The certificate trust evaluation error.
 
 @return The reference to the abstract Core Foundation-type representing RSA public key.
 */
- (SecKeyRef)getPublicKeyAfterEvaluatingTrust:(NSArray<NSData *> *)certificateChainData
                           anchorCertificates:(NSArray<NSData *> *)anchorCertificatesData
                             validCommonNames:(NSArray<NSString *> *)validCommonNames
                                        error:(NSError *__autoreleasing *)error;

/**
 Sets the anchor certificates used when evaluating a trust management object.

 @param certificatesData The list of trusted anchor certificate data.
 @param trustRef The trust management object reference.
 
 @return YES if the anchor certificate was set successfully.
 */
- (BOOL)setTrustedAnchorCertificates:(NSArray<NSData *> *)certificatesData
                               trust:(SecTrustRef)trustRef;

/**
 Evaluate trust object.

 @param trustRef The trust management object you want to evaluate.
 @param error The trust evaluation error.
 
 @return YES if trust evaluation was successful.
 */
- (BOOL)evaluateTrust:(SecTrustRef)trustRef
                error:(NSError *__autoreleasing *)error;

/**
 Get the common name of given certificate.

 @param certificateRef The input certificate reference.
 
 @return The common name of a given certificate.
 */
- (NSString *)commonNameForCertificate:(SecCertificateRef)certificateRef;

@end
