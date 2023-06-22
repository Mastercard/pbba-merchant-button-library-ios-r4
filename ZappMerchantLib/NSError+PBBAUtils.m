//
//  NSError+PBBAUtils.m
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

#import "NSError+PBBAUtils.h"

static NSString * const kPBBAAppPickerErrorDomain = @"com.pbba.app.picker";

static NSString * const kPBBAIvalidAppPickerFormatError = @"[PBBA] Invalid app picker content format.";
static NSString * const kPBBAUnableToRetrieveAppPickerManifestError = @"[PBBA] Unable to retrieve app picker manifest.";
static NSString * const kPBBAUnableToRetrievePublicKeyCertificateError = @"[PBBA] Unable to retrieve public key certificate for app picker manifest verification.";
static NSString * const kPBBAUnableToDecodeJWSContentError = @"[PBBA] Unable to decode JWS content for app picker manifest.";
static NSString * const kPBBAJWSSignatureVerificationError = @"[PBBA] JWS signature verification failed.";
static NSString * const kPBBAInvalidAppIconError = @"[PBBA] The app icon hash doesn't match the one from the app picker manifest.";
static NSString * const kPBBAInvalidPublicKeyCertificateErrorFormat = @"[PBBA] Certificate trust evalutation failure: %@";

@implementation NSError (PBBAUtils)

+ (instancetype)errorWithMessage:(NSString *)message
                            code:(NSInteger)code
{    
    return [NSError errorWithDomain:kPBBAAppPickerErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey:message}];;
}

+ (instancetype)pbba_invalidAppPickerFormatError
{
    return [self errorWithMessage:kPBBAIvalidAppPickerFormatError
                             code:PBBAErrorTypeInvalidAppPickerFormat];
}

+ (instancetype)pbba_unableToRetrieveAppPickerManifestError
{
    return [self errorWithMessage:kPBBAUnableToRetrieveAppPickerManifestError
                             code:PBBAErrorTypeUnableToRetrieveAppPickerManifest];
}

+ (instancetype)pbba_unableToRetrievePublicKeyCertificate
{
    return [self errorWithMessage:kPBBAUnableToRetrievePublicKeyCertificateError
                             code:PBBAErrorTypeUnableToRetrievePublicKeyCertificate];
}

+ (instancetype)pbba_unableToDecodeJWSContentError
{
    return [self errorWithMessage:kPBBAUnableToDecodeJWSContentError
                             code:PBBAErrorTypeUnableToDecodeJWSContent];
}

+ (instancetype)pbba_jwsSignatureVerificationError
{
    return [self errorWithMessage:kPBBAJWSSignatureVerificationError
                             code:PBBAErrorTypeJWSSignatureVerification];
}

+ (instancetype)pbba_invalidAppIconError
{
    return [self errorWithMessage:kPBBAInvalidAppIconError
                             code:PBBAErrorTypeInvalidAppIcon];
}

+ (instancetype)pbba_invalidPublicKeyCertificateErrorWithDetails:(NSString *)details
{
    return [self errorWithMessage:[NSString stringWithFormat:kPBBAInvalidPublicKeyCertificateErrorFormat, details]
                             code:PBBAErrorTypeInvalidPublicKeyCertificate];
}

@end
