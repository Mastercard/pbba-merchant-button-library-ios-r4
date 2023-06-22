//
//  NSError+PBBAUtils.h
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/4/17.
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

#define PBBA_ERROR(ep, e) if (ep) *ep = e

/**
 The PBBA App Picker Library predefined errors.

 - PBBAErrorTypeUnableToRetrieveAppPickerManifest: The retrieval of the app picker manifest file from the CDN has failed.
 - PBBAErrorTypeUnableToRetrievePublicKeyCertificate: The retrieval of the X.509 public key certificate from the CDN has failed.
 - PBBAErrorTypeUnableToDecodeJWSContent: The decoding of the JWS content from the app picker manifest file has failed.
 - PBBAErrorTypeInvalidPublicKeyCertificate: The X.509 public key certificate trust evaluation has failed.
 - PBBAErrorTypeJWSSignatureVerification: The app picker manifest digital signature verification has failed.
 - PBBAErrorTypeInvalidAppPickerFormat: The app picker manifest content has an invalid format.
 - PBBAErrorTypeInvalidAppIcon: The retrieved bank app logo hash verification has failed.
 */
typedef NS_ENUM(NSInteger, PBBAErrorType) {
    PBBAErrorTypeUnableToRetrieveAppPickerManifest,
    PBBAErrorTypeUnableToRetrievePublicKeyCertificate,
    PBBAErrorTypeUnableToDecodeJWSContent,
    PBBAErrorTypeInvalidPublicKeyCertificate,
    PBBAErrorTypeJWSSignatureVerification,
    PBBAErrorTypeInvalidAppPickerFormat,
    PBBAErrorTypeInvalidAppIcon
};

@interface NSError (PBBAUtils)

+ (instancetype)pbba_unableToRetrieveAppPickerManifestError;
+ (instancetype)pbba_unableToRetrievePublicKeyCertificate;
+ (instancetype)pbba_unableToDecodeJWSContentError;
+ (instancetype)pbba_jwsSignatureVerificationError;
+ (instancetype)pbba_invalidAppPickerFormatError;
+ (instancetype)pbba_invalidAppIconError;

+ (instancetype)pbba_invalidPublicKeyCertificateErrorWithDetails:(NSString *)details;

@end
