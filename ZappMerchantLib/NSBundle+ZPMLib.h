//
//  NSBundle+ZPMLib.h
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

#import <Foundation/Foundation.h>

/**
 *  Load localized string from the library resource bundle.
 *
 *  @param key The unique key for the string value.
 *
 *  @return The loaded string for given key.
 */
NSString * PBBALocalizedString(NSString *key);

@interface NSBundle (ZPMLib)

+ (NSBundle *)pbba_merchantResourceBundle;

@end
