//
//  PBBAAppPickerUtils.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/13/17.
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

#import <UIKit/UIKit.h>
#import "PBBAAppPickerUtils.h"
#import "PBBAInvocationURLBuilder.h"

// Request to Link (RTL) is available only in release 4 API
static float const kPBBARequestToLinkMinAPIVersion = 4.0;
static NSString * const kApiName= @"apiName";
static NSString * const kAPINameRequestToPay = @"RequestToPay";
static NSString * const kAPINameRequestToLink = @"RequestToLink";


@implementation PBBAAppPickerUtils

+ (NSArray<PBBAAppPickerItem *> *)filterAppPickerItemsForInstalledApps:(NSArray<PBBAAppPickerItem *> *)items
{
    NSMutableArray *installedItems = [NSMutableArray array];
    for (PBBAAppPickerItem *item in items) {
        if ([self isAppInstalledForAppPickerItem:item]) {
            [installedItems addObject:item];
        }
    }
    return [installedItems copy];
}

+ (NSArray<PBBAAppPickerItem *> *)filterAppPickerItems:(NSArray<PBBAAppPickerItem *> *)items
                                           requestType:(PBBARequestType)requestType
{
    if (requestType == PBBARequestTypeRequestToLink || requestType == PBBARequestTypeRequestToLinkAndPay) {
        NSMutableArray *filteredItems = [NSMutableArray array];
        for (PBBAAppPickerItem *item in items) {
            if (item.apiVersion.floatValue >= kPBBARequestToLinkMinAPIVersion) {
                [filteredItems addObject:item];
            }
        }
        
        return [filteredItems copy];
    }
    return items;
}

+ (BOOL)isAppInstalledForAppPickerItem:(PBBAAppPickerItem *)item
{
    NSURL *testURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://test", item.appURLScheme]];
    return [[UIApplication sharedApplication] canOpenURL:testURL];
}

+ (void)openAppForAppPickerItem:(PBBAAppPickerItem *)item secureToken:(NSString *)secureToken requestType:(PBBARequestType)requestType {
    
    PBBAInvocationURLBuilder *invocationURLBuilder = [PBBAInvocationURLBuilder new];
    [invocationURLBuilder withSecureToken:secureToken];
    [invocationURLBuilder withRequestType:requestType];
    [invocationURLBuilder withCustomScheme:item.appURLScheme];
    
    NSURL *appURLString = [invocationURLBuilder buildWithUniqueScheme];
    
    [[UIApplication sharedApplication] openURL:appURLString options:@{} completionHandler:nil];

}

@end
