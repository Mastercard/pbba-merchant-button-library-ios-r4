//
//  PBBAInvocationURLBuilder.m
//  ZappMerchantLib
//
//  Created by Alex Maimescu on 06/10/2017.
//  Copyright 2016 IPCO 2012 Limited
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

#import "PBBAInvocationURLBuilder.h"

static NSString * const kPBBACFIAppInvocationURLScheme      = @"zapp";
static NSString * const kPBBACFIAppInvocationURLSchemeR4    = @"zapp-r4";

static NSString * const kAPINameRequestToPay = @"RequestToPay";
static NSString * const kAPINameRequestToLink = @"RequestToLink";
static NSString * const kAPINameRequestToLinkAndPay = @"RequestToLinkAndPay";

@interface PBBAInvocationURLBuilder ()

@property (nonatomic) PBBARequestType requestType;
@property (nonatomic) NSString *customScheme;
@property (nonatomic) NSString *secureToken;

@end

@implementation PBBAInvocationURLBuilder

- (instancetype)withCustomScheme:(NSString *)customScheme
{
    self.customScheme = customScheme;
    
    return self;
}

- (instancetype)withRequestType:(PBBARequestType)requestType
{
    self.requestType = requestType;
    
    return self;
}

- (instancetype)withSecureToken:(NSString *)secureToken
{
    self.secureToken = secureToken;
    
    return self;
}

- (NSURL *)build
{
    NSString *scheme = [self pbbaSchemeForRequestType:self.requestType];
    
    NSURLComponents *pbbaURLInvocationComponents = [NSURLComponents new];
    pbbaURLInvocationComponents.scheme = scheme;
    pbbaURLInvocationComponents.host = self.secureToken;
    
    // Add query params only for R4 invocations
    if ([scheme isEqualToString:kPBBACFIAppInvocationURLSchemeR4] && self.secureToken) {
        pbbaURLInvocationComponents.queryItems = @[[self apiNameParamForRequestType:self.requestType]];
    }
    
    return pbbaURLInvocationComponents.URL;
}

- (NSString *)pbbaSchemeForRequestType:(PBBARequestType)requestType
{
    if (self.customScheme) {
        return self.customScheme;
    }
    
    switch (requestType) {
        case PBBARequestTypeRequestToPay:
            return kPBBACFIAppInvocationURLScheme;
            break;
        case PBBARequestTypeRequestToLinkAndPay:
            return kPBBACFIAppInvocationURLScheme;
            break;
        case PBBARequestTypeRequestToLink:
            return kPBBACFIAppInvocationURLSchemeR4;
            break;
    }
    return nil;
}

- (NSURLQueryItem *)apiNameParamForRequestType:(PBBARequestType)requestType
{
    NSString *apiName;
    
    switch (requestType) {
        case PBBARequestTypeRequestToPay:
            apiName = kAPINameRequestToPay;
            break;
        case PBBARequestTypeRequestToLinkAndPay:
            apiName = kAPINameRequestToLinkAndPay;
            break;
        case PBBARequestTypeRequestToLink:
            apiName = kAPINameRequestToLink;
            break;
    }
    
    return [NSURLQueryItem queryItemWithName:@"apiName" value:apiName];
}

@end
