//
//  PBBAAppPickerConfiguration.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 6/26/17.
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

#import "PBBAAppPickerConfiguration.h"
//#import "NSBundle+PBBAUtils.h"

static NSString * const kPBBAAppUniqueCustomSchemeKey = @"com.pbba.appUniqueScheme";

static NSString * const kPBBAAppPickerConfigurationKey = @"PBBAAppPickerConfiguration";
static NSString * const kPBBAAppPickerManifestURLKey = @"PBBAAppPickerManifestURL";
static NSString * const kPBBAAppPickerManifestPublicKeyCertificateCommonaNamesKey = @"PBBAAppPickerManifestPublicKeyCertificateCommonNames";
static NSString * const kPBBAAppPickerManifestTrustedCACertificateNamesKey = @"PBBAAppPickerManifestTrustedCACertificateNames";

// DEBUG Keys

static NSString * const kPBBADebugAnchorTLSCertificateNameKey = @"PBBADebugAnchorTLSCertificateName";

@implementation PBBAAppPickerConfiguration

+ (NSURL *)appPickerManifestURL
{
    NSDictionary *appPickerConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:kPBBAAppPickerConfigurationKey];
    NSString *appPickerManifestURLString = appPickerConfig[kPBBAAppPickerManifestURLKey];
    NSAssert(appPickerManifestURLString,
             @"[PBBA] Missing mandatory value for PBBAAppPickerManifestURL key in Info.plist file.");
    
    return [NSURL URLWithString:appPickerManifestURLString];
}

+ (NSArray<NSString *> *)appPickerManifestPublicKeyCertificateCommonNames
{
    NSDictionary *appPickerConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:kPBBAAppPickerConfigurationKey];
    NSArray<NSString *> *validCommonNames = appPickerConfig[kPBBAAppPickerManifestPublicKeyCertificateCommonaNamesKey];
    NSAssert(validCommonNames,
             @"[PBBA] Missing mandatory value for PBBAAppPickerManifestPublicKeyCertificateCommonNames key in Info.plist file.");
    
    return validCommonNames;
}

+ (NSArray<NSData *> *)trustedAnchorCertificates
{
    NSDictionary *appPickerConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:kPBBAAppPickerConfigurationKey];
    NSArray<NSString *> *trustedCACertificateNames = appPickerConfig[kPBBAAppPickerManifestTrustedCACertificateNamesKey];
    
    NSAssert(trustedCACertificateNames,
             @"[PBBA] Missing mandatory value for PBBAAppPickerManifestTrustedCACertificateNames key in Info.plist file.");
    
    NSMutableArray *trustedCACertificates = [NSMutableArray arrayWithCapacity:trustedCACertificateNames.count];
    for (NSString *trustedCACertificateName in trustedCACertificateNames) {
        NSString *path = [[NSBundle mainBundle] pathForResource:trustedCACertificateName.stringByDeletingPathExtension
                                                         ofType:trustedCACertificateName.pathExtension];
        
        NSAssert(path,
                 ([NSString stringWithFormat:@"[PBBA] Missing in the app main bundle the trusted CA certificate file: %@", trustedCACertificateName]));
        
        [trustedCACertificates addObject:[NSData dataWithContentsOfFile:path]];
    }
    
    return [trustedCACertificates copy];
}

+ (NSData *)debugAnchorTLSCertificate
{
    NSDictionary *appPickerConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:kPBBAAppPickerConfigurationKey];
    NSString *anchorTLSCertificateName = appPickerConfig[kPBBADebugAnchorTLSCertificateNameKey];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:anchorTLSCertificateName.stringByDeletingPathExtension
                                                     ofType:anchorTLSCertificateName.pathExtension];
    
    return [NSData dataWithContentsOfFile:path];
}

@end
