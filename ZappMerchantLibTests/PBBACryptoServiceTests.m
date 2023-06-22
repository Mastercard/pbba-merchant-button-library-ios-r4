//
//  PBBACryptoServiceTests.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 6/1/17.
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
#import "PBBACryptoService.h"
#import "PBBAJSONWebSignatureService.h"
#import "PBBATestData.h"

SPEC_BEGIN(PBBACryptoServiceTests)

describe(@"For PBBACryptoService class", ^{
    
    __block PBBACryptoService *cryptoService;
    
    // Prepare valid test data
    NSString *validJWSContent = [PBBATestData validJWSContent];
    NSData *validCertificateData = [PBBATestData testSelfSignedCertificateData];
    
    NSString *validCommonName = @"retailmine.co.uk";
    
    beforeEach(^{
        cryptoService = [PBBACryptoService new];
    });
    
    it(@"a call to verifySigningInput:signature:certificateData:error: should fail for invalid input data, signature or public key certificate", ^{
        
        __block NSString *input;
        __block NSData *signature;
        NSError *errorToTest;
        
        PBBAJSONWebSignatureService *jwsService = [PBBAJSONWebSignatureService new];
        [jwsService decodeJWS:validJWSContent completion:^(NSDictionary *jwsHeader, NSDictionary *jwsPayload, NSData *jwsSignature, NSString *jwsSigningInput, NSError *error) {
            signature = jwsSignature;
            input = jwsSigningInput;
        }];
        
        // Invalid signing input
        BOOL valid = [cryptoService verifySigningInput:nil
                                             signature:signature
                                      certificateChain:@[validCertificateData]
                                    anchorCertificates:@[validCertificateData]
                                      validCommonNames:@[validCommonName]
                                                 error:&errorToTest];
        
        [[theValue(valid) should] beFalse];
        
        // Invalid signature
        errorToTest = nil;
        valid = [cryptoService verifySigningInput:input
                                        signature:nil
                                 certificateChain:@[validCertificateData]
                               anchorCertificates:@[validCertificateData]
                                 validCommonNames:@[validCommonName]
                                            error:&errorToTest];
        
        [[theValue(valid) should] beFalse];
        
        // Invalid public key certificate
        errorToTest = nil;
        valid = [cryptoService verifySigningInput:input
                                        signature:signature
                                 certificateChain:nil
                               anchorCertificates:nil
                                 validCommonNames:@[validCommonName]
                                            error:&errorToTest];
        
        [[theValue(valid) should] beFalse];
    });
    
    it(@"a call to sha256: should return nil for invalid data", ^{
        
        NSString *appIconHash = [cryptoService sha256:nil];
        
        [[appIconHash should] beNil];
    });
});

SPEC_END
