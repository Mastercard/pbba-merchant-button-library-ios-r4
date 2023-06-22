//
//  PBBAJSONWebSignatureService.m
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

#import "PBBAJSONWebSignatureService.h"

#import "NSString+PBBAUtils.h"
#import "NSError+PBBAUtils.h"

@implementation PBBAJSONWebSignatureService

- (void)decodeJWS:(NSString *)jwsInput
       completion:(PBBAJWSDecodeCompletion)completion
{
    if (!completion) return;
    
    NSArray *segments = [jwsInput componentsSeparatedByString:@"."];
    if (segments.count != 3) {
        completion(nil, nil, nil, nil, [NSError pbba_unableToDecodeJWSContentError]);
        return;
    }
    
    NSString *base64EncodedHeader = segments[0];
    NSString *base64EncodedPayload = segments[1];
    NSString *base64EncodedSignature = segments[2];
    
    NSError *decodingError;
    
    // Decode JWS header
    NSDictionary *header = [self decodeBase64EncodedStringToJSONDictionary:[base64EncodedHeader pbba_trim] error:&decodingError];
    
    // Decode JWS payload
    NSDictionary *payload = [self decodeBase64EncodedStringToJSONDictionary:[base64EncodedPayload pbba_trim] error:&decodingError];
    
    // Decode signature
    NSData *signature = [self decodeBase64EncodedStringToData:[base64EncodedSignature pbba_trim] error:&decodingError];
    
    NSString *signingInput = [NSString stringWithFormat:@"%@.%@", base64EncodedHeader, base64EncodedPayload];
                   
    completion(header, payload, signature, signingInput, decodingError);
}

- (NSData *)decodeBase64EncodedStringToData:(NSString *)base64EncodedString
                                      error:(NSError *__autoreleasing *)error
{
    NSData *decodedData = [base64EncodedString pbba_URLSafeBase64Decode];
    if (!decodedData) {
        PBBA_ERROR(error, [NSError pbba_unableToDecodeJWSContentError]);
        
        return nil;
    }
    
    return decodedData;
}

- (NSDictionary *)decodeBase64EncodedStringToJSONDictionary:(NSString *)base64EncodedString
                                                      error:(NSError *__autoreleasing *)error
{
    NSData *decodedData = [self decodeBase64EncodedStringToData:base64EncodedString error:error];
    if (decodedData) {
        return [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:error];
    }
    
    return nil;
}

@end
