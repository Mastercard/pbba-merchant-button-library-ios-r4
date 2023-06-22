//
//  PBBALibraryUtils.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 6/27/16.
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

#import <UIKit/UIKit.h>

#import "PBBALibraryUtils.h"
#import "PBBAInvocationURLBuilder.h"
#import "PBBAAppPickerViewController.h"
#import "NSBundle+PBBAUtils.h"

NSString * const kPBBACustomThemeKey = @"pbbaTheme";
NSString * const kPBBACFIAppNameKey = @"cfiAppName";
NSString * const kPBBACFILogosKey = @"showCFILogos";

static NSString * const kPBBACustomConfigFileName           = @"pbbaCustomConfig";

static NSString * const kPBBAPaymentsInfoURLString          = @"http://www.paybybankapp.co.uk/how-it-works/the-experience/";
static NSString * const kPBBARememberCFIAppLaunchKey        = @"com.zapp.bankapp.remembered";
static NSString * const kPBBAAppPickerApps = @"LSApplicationQueriesSchemes";

static NSDictionary *sPBBACustomConfig = nil;
static NSString *sPBBACustomScheme = nil;

static NSArray *installedItems = nil;

@implementation PBBALibraryUtils

+ (NSDictionary *)pbbaCustomConfig
{
    if (sPBBACustomConfig == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:kPBBACustomConfigFileName ofType:@"plist"];
        sPBBACustomConfig = [NSDictionary dictionaryWithContentsOfFile:path];
        [self saveFlagValue:[sPBBACustomConfig [kPBBACFILogosKey] boolValue] forKey:kPBBACFILogosKey];
    }
    return sPBBACustomConfig;
}

+ (void)setPBBACustomConfig:(NSDictionary *)config
{
    sPBBACustomConfig = config;
}

+ (void)setPBBACustomScheme:(NSString *)customScheme
{
    sPBBACustomScheme = customScheme;
}

+ (BOOL)isCFIAppAvailableForRequestType:(PBBARequestType)requestType
{
    NSArray *appsArray = [self appPickerAppsList];
    
    NSMutableArray *installedItems = [NSMutableArray array];
    for (NSString *appURL in appsArray) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://test", appURL]]]) {
            [installedItems addObject:appURL];
        }
    }    
    
    if (installedItems.count) {
        return YES;
    } else {
        [self saveFlagValue:NO forKey:kPBBARememberCFIAppLaunchKey];
        return NO;
    }

}

+ (BOOL)openBankingApp:(NSString *)secureToken requestType:(PBBARequestType)requestType
{
    if (secureToken) {
        PBBAInvocationURLBuilder *invocationURLBuilder = [PBBAInvocationURLBuilder new];
        [invocationURLBuilder withSecureToken:secureToken];
        [invocationURLBuilder withRequestType:requestType];
        [invocationURLBuilder withCustomScheme:sPBBACustomScheme];
        
        NSURL *invocationURL = [invocationURLBuilder build];
        
        return [[UIApplication sharedApplication] openURL:invocationURL];
    }
    
    return NO;
}

+ (void)openAppPicker:(NSString *_Nullable)secureToken requestType:(PBBARequestType)requestType brn:(NSString *_Nullable)brn expiryInterval:(NSUInteger) expiryInterval presenter:(UIViewController *_Nullable)presenter {
    PBBAAppPickerViewController *appPickerViewController = [[PBBAAppPickerViewController alloc] initWithNibName:@"PBBAAppPickerViewController" bundle:[NSBundle pbba_bundle]];
    appPickerViewController.providesPresentationContextTransitionStyle = YES;
    appPickerViewController.definesPresentationContext = YES;
    [appPickerViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    appPickerViewController.delegate = presenter;
    appPickerViewController.requestType = requestType;
    appPickerViewController.secureToken = secureToken;
    appPickerViewController.presenter = presenter;
    appPickerViewController.brn = brn;
    appPickerViewController.expiryInterval = expiryInterval;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:appPickerViewController animated:YES completion:nil];
}

+ (void)registerCFIAppLaunch
{
    [self saveFlagValue:YES forKey:kPBBARememberCFIAppLaunchKey];
}

+ (void)saveFlagValue:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)wasCFIAppLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPBBARememberCFIAppLaunchKey];
}

+ (BOOL)shouldLaunchCFIAppForRequestType:(PBBARequestType)requestType
{
    return [self wasCFIAppLaunched] && [self isCFIAppAvailableForRequestType:requestType];
}


+(BOOL)shouldShowCFILogos
{
    if ([self pbbaCustomConfig]) {
        //make sure the configurations are loaded from the Appconfig.plist
    }
    return  [[NSUserDefaults standardUserDefaults] boolForKey:kPBBACFILogosKey];
}

+ (NSArray<NSString *> *)appPickerAppsList
{
    NSArray *appPickerQueriedURLSchemes = [[NSBundle mainBundle] objectForInfoDictionaryKey:kPBBAAppPickerApps];
    NSAssert(appPickerQueriedURLSchemes,
             @"[PBBA] Missing mandatory value for LSApplicationQueriesSchemes key in Info.plist file.");
    return appPickerQueriedURLSchemes;
}

@end
