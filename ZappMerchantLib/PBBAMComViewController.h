//
//  PBBAMComViewController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/7/16.
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

#import "PBBAPopupContentViewController.h"

@class PBBAPopupButton;

/**
 *  M-Commerce payment flow view controller
 */
@interface PBBAMComViewController : PBBAPopupContentViewController

/**
 *  The Basket Reference Number for entry in the CFI app on the consumer’s device.
 */
@property (nonatomic, copy) NSString *brn;

/**
 *  Call to open banking app section title
 */
@property (nonatomic, copy) NSString *openBankingAppTitle;

/**
 *  Call to open banking app section message
 */
@property (nonatomic, copy) NSString *openBankingAppMessage;

/**
 *  Call to open banking app section button
 */
@property (nonatomic, weak, readonly) PBBAPopupButton *openBankingAppButton;

/**
 *  Get PBBA code section title
 */
@property (nonatomic, copy) NSString *getZappCodeTitle;

/**
 *  Get PBBA code section message
 */
@property (nonatomic, copy) NSString *getZappCodeMessage;

/**
 *  Get PPBA code section button
 */
@property (nonatomic, weak, readonly) PBBAPopupButton *getZappCodeButton;

/**
 *  PBBA code instructions section title
 */
@property (nonatomic, copy) NSString *codeInstructionsTitle;

@end
