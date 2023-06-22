//
//  PBBAJSONWebSignatureServiceTests.m
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

#import "PBBATestEnvironment.h"
#import "PBBAJSONWebSignatureService.h"
#import "PBBATestData.h"

SPEC_BEGIN(PBBAJSONWebSignatureServiceTests)

describe(@"For PBBAJSONWebSignatureService class", ^{
    
    __block PBBAJSONWebSignatureService *jwsService;
    
    // Prepare valid test data
    NSString *validJWSContent = [PBBATestData validJWSContent];
    NSDictionary *validJWSHeader = [PBBATestData validJWSHeader];
    NSDictionary *validJWSPayload = [PBBATestData validAppPickerManifest];
    
    beforeEach(^{
        jwsService = [PBBAJSONWebSignatureService new];
    });
    
    it(@"a call to decodeJWS:completion: returns properly decoded JWS header", ^{
        
        __block NSDictionary *jwsHeaderToTest;
        
        [jwsService decodeJWS:validJWSContent completion:^(NSDictionary *jwsHeader, NSDictionary *jwsPayload, NSData *jwsSignature, NSString *jwsSigningInput, NSError *error) {
            jwsHeaderToTest = jwsHeader;
        }];
        
        // Verify header fields
        [[expectFutureValue(theValue(jwsHeaderToTest.allKeys.count)) shouldEventually] equal:theValue(3)];
        [[expectFutureValue(jwsHeaderToTest.description) shouldEventually] equal:validJWSHeader.description];
    });

    it(@"a call to decodeJWS:completion: returns properly decoded JWS signaure", ^{
        
        __block NSDictionary *jwsPayloadToTest;
        
        [jwsService decodeJWS:validJWSContent completion:^(NSDictionary *jwsHeader, NSDictionary *jwsPayload, NSData *jwsSignature, NSString *jwsSigningInput, NSError *error) {
            jwsPayloadToTest = jwsPayload;
        }];
        
        // Verify header fields
        [[expectFutureValue(theValue(jwsPayloadToTest.allKeys.count)) shouldEventually] equal:theValue(3)];
        [[expectFutureValue(jwsPayloadToTest.description) shouldEventually] equal:validJWSPayload.description];
    });
    
    it(@"a call to decodeJWS:completion: returns properly decoded JWS signature", ^{
        
        __block NSData *jwsSignatureToTest;
        
        [jwsService decodeJWS:validJWSContent completion:^(NSDictionary *jwsHeader, NSDictionary *jwsPayload, NSData *jwsSignature, NSString *jwsSigningInput, NSError *error) {
            jwsSignatureToTest = jwsSignature;
        }];
        
        // Verify header fields
        [[expectFutureValue(jwsSignatureToTest) shouldEventually] beNonNil];
    });
});

SPEC_END
