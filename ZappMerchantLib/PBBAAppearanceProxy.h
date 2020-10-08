//
//  PBBAAppearanceProxy.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/15/16.
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
 *  Appearance proxy object
 */
@interface PBBAAppearanceProxy : NSProxy

/**
 *  Get an appearance proxy object for given class
 *
 *  @param someClass given class
 *
 *  @return instance of appearance proxy
 */
+ (id)appearanceForClass:(Class)someClass;

/**
 *  Start forwarding collected invocations
 *
 *  @param target all the invocations will be send to this target
 */
- (void)startForwarding:(id)target;

@end
