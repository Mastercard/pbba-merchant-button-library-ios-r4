//
//  PBBAAppPickerItem.h
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

#import <Foundation/Foundation.h>

@interface PBBAAppPickerItem : NSObject

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSURL *appIconURL;
@property (nonatomic, copy) NSString *appIconHash;
@property (nonatomic, copy) NSString *appURLScheme;
@property (nonatomic, copy) NSNumber *apiVersion;

- (instancetype)initWithDictionary:(NSDictionary *)json
                             error:(NSError *__autoreleasing *)error;

@end
