//
//  PBBAJSONWebSignatureService.h
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/24/17.
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
 The JWS decoding completion handler.

 @param jwsHeader The JWS header.
 @param jwsPayload The JWS payload which represents the app picker manifest.
 @param jwsSignature The JWS signature (RSA signature with SHA-256 digest).
 @param jwsSigningInput The JWS signing input.
 @param error The JWS decoding error. Is nil if decoding was successful.
 */
typedef void (^PBBAJWSDecodeCompletion)(
    NSDictionary *jwsHeader,
    NSDictionary *jwsPayload,
    NSData *jwsSignature,
    NSString *jwsSigningInput,
    NSError *error);

/**
 Service class for JSON Web Signature (JWS) related operations.
 
 JSON Web Signature (JWS) represents content secured with digital
 signatures or Message Authentication Codes (MACs) using JSON-based
 data structures.
 
 See https://tools.ietf.org/html/rfc7515 for more details.
 */
@interface PBBAJSONWebSignatureService : NSObject

/**
 Decode JWS input string.

 @param jwsInput The JWS input string.
 @param completion The JWS decoding completion handler.
 */
- (void)decodeJWS:(NSString *)jwsInput
       completion:(PBBAJWSDecodeCompletion)completion;

@end
