//
//  PBBAAppPickerViewController.h
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/7/17.
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

#import <UIKit/UIKit.h>
#import "PBBATypes.h"
#import "PBBAPopupViewController.h"

@class PBBAAppPickerViewController;


/**
 The PBBA App Picker view controller delegate protocol definition.
 */
@protocol PBBAAppPickerViewControllerDelegate <NSObject>
@optional

/**
 Inform delegate whether the app picker will show the app picker items.

 @param pbbaAppPickerViewController The instance of PBBAAppPickerViewController.
 @param willShow The flag which indicates whether the app picker will show the app picker items.
 
 @discussion If willShow flag is NO, it means that the host app is the only PBBA enabled app installed on the device.
 */
- (void)pbbaAppPickerViewController:(nonnull PBBAAppPickerViewController *)pbbaAppPickerViewController
             willShowAppPickerItems:(BOOL)willShow;

/**
 Inform delegate that the app picker did fail to show the app picker items.

 @param pbbaAppPickerViewController The instance of PBBAAppPickerViewController.
 @param error The error which describes the reason of the failure.
 */
- (void)pbbaAppPickerViewController:(nonnull PBBAAppPickerViewController *)pbbaAppPickerViewController
                   didFailWithError:(nonnull NSError *)error;

/**
 Inform delegate that the app picker UI will appear on screen.

 @param pbbaAppPickerViewController The instance of PBBAAppPickerViewController.
 */
- (void)pbbaAppPickerViewControllerWillAppear:(nonnull PBBAAppPickerViewController *)pbbaAppPickerViewController;

/**
 Inform delegate that the app picker UI did disappear from the screen.
 
 @param pbbaAppPickerViewController The instance of PBBAAppPickerViewController.
 */
- (void)pbbaAppPickerViewControllerDidDisappear:(nonnull PBBAAppPickerViewController *)pbbaAppPickerViewController;

@end



/**
 The PBBA App Picker view controller.
 */
@interface PBBAAppPickerViewController : UIViewController

/**
 The URL which was used to invoke the CFI app from merchant app or website.
 */
@property (nonatomic, readonly, nonnull) NSURL *invocationURL;

/**
 The PBBA App Picker view controller delegate.
 */
@property (nonatomic, weak, nullable) id<PBBAAppPickerViewControllerDelegate> delegate;

@property (assign, nonatomic) PBBARequestType requestType;

@property (nonatomic, weak) UIViewController * _Nullable presenter;

/**
 *  The human friendly transaction retrieval identifier issued by Zapp.
 */
@property (nullable, nonatomic, copy) NSString *secureToken;

/**
 *  The Basket Reference Number for entry in the CFI app on the consumer’s device.
 */
@property (nullable, nonatomic, copy) NSString *brn;

/**
 *  The expiration interval to be shown in the popup
 */
@property (nonatomic) NSUInteger expiryInterval;

@end
