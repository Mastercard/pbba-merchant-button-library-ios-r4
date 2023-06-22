//
//  PBBACertificateTrustServiceTests.m
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

#import "PBBATestEnvironment.h"
#import "PBBACertificateTrustService.h"
#import "PBBATestData.h"

SPEC_BEGIN(PBBACertificateServiceTests)

describe(@"For PBBACertificateTrustService class", ^{
    
    __block PBBACertificateTrustService *certificateService;
    
    // Leaf certificate
    NSData *testLeafCertificateData = [PBBATestData testLeafCertificateData];
    
    // The CA for the leaf certificate
    NSData *testCACertificateData = [PBBATestData testCACertificateData];
    
    NSString *validCommonName = @"App Picker Manifest Signature Verification Certificate";
    
    beforeEach(^{
        certificateService = [PBBACertificateTrustService new];
    });
    
    it(@"a call to setTrustedAnchorCertificates:trust: should return NO for missing input certificates", ^{
        
        BOOL didSet = [certificateService setTrustedAnchorCertificates:nil trust:NULL];
        
        [[theValue(didSet) should] beFalse];
    });
    
    it(@"a call to derCertificateChainForPEMChain: should return nothing for nil input", ^{
        
        NSArray<NSData *> *derCertificates = [certificateService derCertificateChainForPEMChain:nil];
        
        [[derCertificates should] beNil];
    });
    
    it(@"a call to derCertificateChainForPEMChain: should return nothing for invalid input", ^{
        
        NSArray<NSData *> *derCertificates = [certificateService derCertificateChainForPEMChain:@"Hello World"];
        
        [[derCertificates should] beNil];
    });
    
    it(@"a call to derCertificateChainForPEMChain: should return nothing for invalid chain", ^{
        
        NSString *invalidPEMChain = [PBBATestData testInvalidCertificateChain];
        NSArray<NSData *> *derCertificates = [certificateService derCertificateChainForPEMChain:invalidPEMChain];
        
        [[derCertificates should] beNil];
    });
    
    it(@"a call to derCertificateChainForPEMChain: should return nothing for invalid chain", ^{
        
        NSString *invalidPEMChain = [PBBATestData testInvalidCertificateChain2];
        NSArray<NSData *> *derCertificates = [certificateService derCertificateChainForPEMChain:invalidPEMChain];
        
        [[derCertificates should] beNil];
    });
    
    it(@"a call to commonNameForCertificate: should return nil for missing input certificate", ^{
        
        NSString *commonName = [certificateService commonNameForCertificate:nil];
        
        [[commonName should] beNil];
    });
});

SPEC_END
