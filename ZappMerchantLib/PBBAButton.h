//
//  PBBAButton.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 7/10/15.
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
#import "PBBAAnimatable.h"
#import "PBBAUIElementAppearance.h"

@class PBBAButton;

/**
 *  PBBA payment button delegate.
 */

@protocol PBBAButtonDelegate <NSObject>

/**
 *  Tell the delegate that payment button was pressed.
 *
 *  @param pbbaButton The instance of payment button which was pressed.
 *
 *  @return YES if you want to disable the payment button and start payment activity animation.
 */
- (BOOL)pbbaButtonDidPress:(nonnull PBBAButton *)pbbaButton;

@end


/**
 *  Pay by Bank app button.
 */
@interface PBBAButton : UIView <PBBAUIElementAppearance>

/**
 * Simulated UIControl property "enabled"
 */
@property(nonatomic, getter=isEnabled) BOOL enabled;

/**
 *  The payment button delegate.
 */
@property (nullable, nonatomic, weak) IBOutlet id<PBBAButtonDelegate> delegate;

@end
