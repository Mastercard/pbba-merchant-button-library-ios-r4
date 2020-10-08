//
//  NSBundle+ZPMLib.m
//  ZappMerchantLib
//
//  Created by Alex Maimescu on 3/17/14.
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

#import "PBBAButton.h"
#import "PBBALibraryUtils.h"

static NSString * const kMerchantLibResourcesBundle = @"ZappMerchantLibResources";

@implementation NSBundle (ZPMLib)

+ (NSBundle *)pbba_merchantResourceBundle
{
    // Load resource bundle included in the main bundle
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:kMerchantLibResourcesBundle withExtension:@"bundle"];
    
    if (!bundleUrl) {
        // Load resource bundle included in framework bundle
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[PBBAButton class]];
        bundleUrl = [frameworkBundle URLForResource:kMerchantLibResourcesBundle withExtension:@"bundle"];
    }
    
    return bundleUrl ? [NSBundle bundleWithURL:bundleUrl] : [NSBundle mainBundle];
}

@end

NSString * PBBALocalizedString(NSString *key) {
    
    NSDictionary *customConfig = [PBBALibraryUtils pbbaCustomConfig];
    PBBACFIAppNameType cfiAppNameType = PBBACFIAppNameTypeDefault;
    
    // Apply a custom generic name for CFI if the theme is PBBA
    PBBAThemeType themeType = [customConfig[kPBBACustomThemeKey] integerValue];
    if (themeType == PBBAThemeTypePBBA && customConfig[kPBBACFIAppNameKey]) {
        cfiAppNameType = [customConfig[kPBBACFIAppNameKey] integerValue];
    }
    
    // Load Pingit specific text value
    NSString *loadedString;
    if (cfiAppNameType == PBBACFIAppNameTypePingit) {
        loadedString = NSLocalizedStringFromTableInBundle(key, @"Localizable-Pingit", [NSBundle pbba_merchantResourceBundle], nil);
    }
    
    // If the specific override was not loaded then load the default string value
    if (loadedString == nil || [loadedString isEqualToString:key]) {
        loadedString = NSLocalizedStringFromTableInBundle(key, nil, [NSBundle pbba_merchantResourceBundle], nil);
    }
    
    return loadedString;
};

