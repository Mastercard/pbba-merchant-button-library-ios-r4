//
//  PBBAPopupViewController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/3/16.
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
#import <Foundation/Foundation.h>
#import "PBBATypes.h"
#import "PBBAUIElementAppearance.h"
#import "PBBAPopupCoordinator.h"
#import "PBBAPopupContainerController.h"

@class PBBAPopupViewController, PBBABankLogosService;

/**
 *  The PBBA popup view controller delegate protocol.
 */
@protocol PBBAPopupViewControllerDelegate <NSObject>

/**
 *  The error popup might ask delegate to retry payment request.
 *
 *  @param pbbaPopupViewController The instance of error popup view controller.
 */
- (void)pbbaPopupViewControllerRetryPaymentRequest:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

@optional

/**
 *  Inform delegate that popup expired. (expiry interval is 0)
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerDidExpire:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

/**
 *  Inform delegate that user has decided to close the popup by pressing the close button.
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerDidCloseByUser:(nonnull PBBAPopupViewController *)pbbaPopupViewController NS_SWIFT_NAME(pbbaPopupViewControllerDidCloseByUser(_:));

/**
 *  Inform delegate that PBBAPopupViewController will appear on the screen.
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerWillAppear:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

/**
 *  Inform delegate that PBBAPopupViewController did appear on the screen.
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerDidAppear:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

/**
 *  Inform delegate that PBBAPopupViewController will disappear from the screen.
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerWillDisappear:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

/**
 *  Inform delegate that PBBAPopupViewController did disappear from the screen.
 *
 *  @param pbbaPopupViewController The instance of popup view controller.
 */
- (void)pbbaPopupViewControllerDidDisappear:(nonnull PBBAPopupViewController *)pbbaPopupViewController;

@end



/**
 *  PBBA popup view controller.
 */
@interface PBBAPopupViewController : UIViewController
/**
 *  The expiration interval to be shown in the popup
 */
@property (nonatomic) NSUInteger expiryInterval;

/**
 *  The human friendly transaction retrieval identifier issued by Zapp.
 */
@property (nullable, nonatomic, readonly) NSString *secureToken;

/**
 *  The Basket Reference Number for entry in the CFI app on the consumer’s device.
 */
@property (nullable, nonatomic, readonly) NSString *brn;

/**
 *  The error code to be displayed inside the error popup.
 */
@property (nullable, nonatomic, readonly) NSString *errorCode;

/**
 *  The error title to be displayed inside the error popup.
 */
@property (nullable, nonatomic, readonly) NSString *errorTitle;

/**
 *  The error message to be displayed inside the error popup.
 */
@property (nullable, nonatomic, readonly) NSString *errorMessage;

/**
 *  The popup view controller delegate.
 */
@property (nullable, nonatomic, weak) id<PBBAPopupViewControllerDelegate> delegate;

@property (nonatomic, strong) PBBAPopupCoordinator * _Nullable popupCoordinator;

@property (nonatomic, strong) PBBAPopupContainerController * _Nullable containerViewController;

/**
 *  Create an instance of PBBA popup view controller.
 *
 *  @param secureToken The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn         The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *  @param requestType The PBBA API request type.
 *  @param delegate    The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController.
 */
- (void)setSecureToken:(nonnull NSString *)secureToken
                                        brn:(nonnull NSString *)brn
                                requestType:(PBBARequestType)requestType
                                   delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate;

/**
 *  Create an instance of PBBA error popup view controller.
 *
 *  @param errorCode    The error code to be displayed inside the error popup.
 *  @param errorTitle   The error title to be displayed inside the error popup.
 *  @param errorMessage The error message to be displayed inside the error popup.
 *  @param delegate     The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController.
 */
- (void)setErrorCode:(nullable NSString *)errorCode
                               errorTitle:(nullable NSString *)errorTitle
                             errorMessage:(nonnull NSString *)errorMessage
                                 delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate;

/**
 *  Update the instance of PBBA popup view controller.
 *
 *  @param secureToken The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn         The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *
 *  @return The instance of PBBAPopupViewController.
 */
- (void)updateSecureToken:(nonnull NSString *)secureToken
                                          brn:(nonnull NSString *)brn;

/**
 *  Update the instance of PBBA popup view controller.
 *
 *  @param errorCode    The error code to be displayed inside the error popup.
 *  @param errorTitle   The error title to be displayed inside the error popup.
 *  @param errorMessage The error message to be displayed inside the error popup.
 *
 *  @return The instance of PBBAPopupViewController.
 */
- (void)updateErrorCode:(nullable NSString *)errorCode
                                 errorTitle:(nullable NSString *)errorTitle
                               errorMessage:(nonnull NSString *)errorMessage NS_SWIFT_NAME(update(withErrorCode:errorTitle:errorMessage:));
/**
 *  Update the instance of PBBA popup view controller
 *  for More About Layout.
 *  @param logosService    The logosService
 */
- (void)updateForMoreAboutWithBankLogosService: (PBBABankLogosService*) logosService;


@end


