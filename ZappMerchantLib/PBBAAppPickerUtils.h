//
//  PBBAAppPickerUtils.h
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

#import <Foundation/Foundation.h>
#import "PBBAAppPickerItem.h"
#import "PBBATypes.h"

/**
 The PBBA App Picker utilities.
 */
@interface PBBAAppPickerUtils : NSObject


/**
 Filter out the app picker items for apps which are not installed on the device.

 @param items The list of the app picker items to be filtered.
 
 @return The filtered list of the app picker items.
 */
+ (NSArray<PBBAAppPickerItem *> *)filterAppPickerItemsForInstalledApps:(NSArray<PBBAAppPickerItem *> *)items;

/**
 Filter out the app picker items for the given request type.

 @param items The list of the app picker items to be filtered.
 @param requestType The request type.
 
 @return The filtered list of the app picker items.
 */
+ (NSArray<PBBAAppPickerItem *> *)filterAppPickerItems:(NSArray<PBBAAppPickerItem *> *)items
                                           requestType:(PBBARequestType)requestType;

/**
 Check whether the app corresponding to the given app picker item is installed on the device.

 @param item The app picker item to be checked.
 
 @return YES if the app corresponding to the given app picker item is installed on the device. Otherwise NO.
 */
+ (BOOL)isAppInstalledForAppPickerItem:(PBBAAppPickerItem *)item;

/**
 Invoke the app corresponding to the given app picker item.

 @param item The app picker item for which the app should be invoked.
 @param secureToken    The human friendly transaction retrieval identifier issued by Zapp.
 @param requestType The request type.
 */
+ (void)openAppForAppPickerItem:(PBBAAppPickerItem *)item secureToken:(nonnull NSString *)secureToken requestType:(PBBARequestType)requestType;

@end

