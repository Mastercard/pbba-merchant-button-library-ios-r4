//
//  PBBAInvocationURLBuilderTests.m
//  ZappMerchantLibTests
//
//  Created by Alex Maimescu on 09/10/2017.
//  Copyright (c) 2020 Mastercard
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
#import "PBBAInvocationURLBuilder.h"

SPEC_BEGIN(PBBAInvocationURLBuilderTests)

describe(@"For PBBAInvocationURLBuilder class", ^{

    __block PBBAInvocationURLBuilder *builder;
    
    NSString * const kTestSecureToken = @"123456789";
    
    beforeEach(^{
        builder = [PBBAInvocationURLBuilder new];
    });
    
    it(@"a call to buildWithUniqueScheme should create a test invocation for scheme if secure token provided and request type is payment", ^{
        [builder withRequestType:PBBARequestTypeRequestToPay];
        [builder withSecureToken:kTestSecureToken];

        NSURL *urlInvocation = [builder buildWithUniqueScheme];
        [[urlInvocation.query should] beNil];
        [[urlInvocation.host should] equal:kTestSecureToken];
    });

    it(@"a call to buildWithUniqueScheme should create a test invocation for R4 scheme if secure token provided and request type is link", ^{
        [builder withRequestType:PBBARequestTypeRequestToLink];
        [builder withSecureToken:kTestSecureToken];

        NSURL *urlInvocation = [builder buildWithUniqueScheme];
        [[urlInvocation.query should] equal:@"apiName=RequestToLink"];
        [[urlInvocation.host should] equal:kTestSecureToken];
    });
    
    it(@"a call to buildWithUniqueScheme should create a test invocation for scheme if no secure token provided and request type is payment", ^{
        [builder withRequestType:PBBARequestTypeRequestToPay];
        [builder withSecureToken:nil];

        NSURL *urlInvocation = [builder buildWithUniqueScheme];
        [[urlInvocation.query should] beNil];
        [[urlInvocation.host should] beNil];
    });

    it(@"a call to buildWithUniqueScheme should create a test invocation for R4 scheme if no secure token provided and request type is link", ^{
        [builder withRequestType:PBBARequestTypeRequestToLink];
        [builder withSecureToken:nil];

        NSURL *urlInvocation = [builder buildWithUniqueScheme];
        [[urlInvocation.query should] beNil];
        [[urlInvocation.host should] beNil];
    });
});
    
SPEC_END
