//
//  PBBAAppPickerServiceTests.m
//  PBBAAppPickerServiceTests
//
//  Created by Alexandru Maimescu on 4/19/17.
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
#import "PBBAAppPickerService.h"

@interface PBBAAppPickerService (Testable)

@property (nonatomic, strong) NSURLSession *appPickerManifestURLSession;
@property (nonatomic, strong) NSURLSession *appIconURLSession;

@end

SPEC_BEGIN(PBBAAppPickerServiceTests)

describe(@"For PBBAAppPickerService class", ^{

    __block PBBAAppPickerService *appPickerService;
    
    beforeEach(^{
        appPickerService = [PBBAAppPickerService new];
    });
    
    it(@"a call to appPickerManifestURLSession should return a properly configured session", ^{
        
        NSURLSessionConfiguration *sessionConfig = appPickerService.appPickerManifestURLSession.configuration;
        
        // The expiration headers should be ignored for app picker manifest
        [[theValue(sessionConfig.requestCachePolicy) should] equal:theValue(NSURLRequestReloadIgnoringCacheData)];
        // Request timeout should be 10 seconds
        [[theValue(sessionConfig.timeoutIntervalForRequest) should] equal:theValue(10)];
        // Minimum TLS version should be 1.2
        [[theValue(sessionConfig.TLSMinimumSupportedProtocol) should] equal:theValue(kTLSProtocol12)];
    });
    
    it(@"a call to appIconURLSession should return a properly configured session", ^{
        
        NSURLSessionConfiguration *sessionConfig = appPickerService.appIconURLSession.configuration;
        
        // The expiration headers should used for caching the images
        [[theValue(sessionConfig.requestCachePolicy) should] equal:theValue(NSURLRequestUseProtocolCachePolicy)];
        // Request timeout should be default (60 seconds)
        [[theValue(sessionConfig.timeoutIntervalForRequest) should] equal:theValue(60)];
        // Minimum TLS version should be 1.2
        [[theValue(sessionConfig.TLSMinimumSupportedProtocol) should] equal:theValue(kTLSProtocol12)];
    });
});

SPEC_END
