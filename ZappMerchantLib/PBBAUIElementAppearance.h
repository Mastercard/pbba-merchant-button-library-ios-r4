//
//  PBBAUIElementAppearance.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 7/6/15.
//  Copyright 2016 IPCO 2012 Limited
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

#ifndef ZappMerchantLib_PBBAUIElementAppearance_h
#define ZappMerchantLib_PBBAUIElementAppearance_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  Set appearance for UI elements
 */
@protocol PBBAUIElementAppearance <UIAppearance>

/**
 *  Set element border color.
 */
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

/**
 *  Set element border witdh.
 */
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 *  Set element corner radius.
 */
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 *  Set element background color.
 */
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 *  Set element foreground color.
 */
@property (nonatomic, strong) UIColor *foregroundColor UI_APPEARANCE_SELECTOR;

/**
 *  Set element secondary foreground color.
 */
@property (nonatomic, strong) UIColor *secondaryForegroundColor UI_APPEARANCE_SELECTOR;

@end

#endif
