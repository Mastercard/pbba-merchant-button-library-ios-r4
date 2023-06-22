//
//  PBBAAppPickerService.h
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/11/17.
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

#import "PBBAAppPickerItem.h"

/**
 Get app picker items completion handler.

 @param items The app picker items.
 @param error The app picker items retrieval error.
 */
typedef void (^PBBAAppPickerItemsCompletionHandler)(NSArray<PBBAAppPickerItem *> *items, NSError *error);

/**
 Get CFI app icon completion handler.

 @param appIcon The CFI app icon.
 @param error The app icon retrieval error.
 */
typedef void (^PBBAAppIconCompletionHandler)(UIImage *appIcon, NSError *error);

/**
 The PBBA App Picker service class.
 */
@interface PBBAAppPickerService : NSObject

/**
 Get the app picker items.

 @param completion The completion handler.
 */
- (void)getAppPickerItems:(PBBAAppPickerItemsCompletionHandler)completion;

/**
 Get the CFI app icon.

 @param url The CFI app icon URL.
 @param appIconHash The CFI app icon SHA-256 digest.
 @param completion The completion handler.
 */
- (void)getAppIconWithURL:(NSURL *)url
              appIconHash:(NSString *)appIconHash
               completion:(PBBAAppIconCompletionHandler)completion;

@end
