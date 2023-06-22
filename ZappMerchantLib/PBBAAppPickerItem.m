//
//  PBBAAppPickerItem.m
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
#import "NSError+PBBAUtils.h"

@implementation PBBAAppPickerItem

- (instancetype)initWithDictionary:(NSDictionary *)json
                             error:(NSError *__autoreleasing *)error
{
    if (self = [super init]) {
        self.appName = json[@"appName"];
        self.appIconURL = [NSURL URLWithString:json[@"appIconURL"]];
        self.appIconHash = json[@"appIconHash"];
        self.appURLScheme = json[@"appURLScheme"];
        self.apiVersion = json[@"apiVersion"];
    }
    
    // Failed to map json dictionary to the model
    if ([self validate:error] == NO) {
        return nil;
    }
    
    return self;
}

- (BOOL)validate:(NSError *__autoreleasing *)error
{
    if (self.appName == nil ||
        self.appIconURL == nil ||
        self.appURLScheme == nil
        ) {
        
        PBBA_ERROR(error, [NSError pbba_invalidAppPickerFormatError]);
        
        return NO;
    }
    
    return YES; // Model is valid by default
}

@end
