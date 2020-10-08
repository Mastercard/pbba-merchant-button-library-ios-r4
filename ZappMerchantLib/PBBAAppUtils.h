//
//  PBBAAppUtils.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 6/27/16.
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
#import "PBBAPopupViewController.h"


@class PBBABankLogosService;

/**
 *  The utils class with helper methods.
 */
@interface PBBAAppUtils : NSObject

/**
 *  Check if at least one PBBA enabled CFI app is installed on the current device for the given request type.
 *
 *  @param requestType The PBBA API request type.
 *
 *  @note You must whitelist first the 'zapp' and 'zapp-r4' scheme in your Info.plist file under the LSApplicationQueriesSchemes key.
 *
 *  @return YES if CFI app is installed.
 */
+ (BOOL)isCFIAppAvailableForRequestType:(PBBARequestType)requestType;

/**
 *  Open the PBBA enabled CFI app.
 *
 *  @param secureToken The secure token to retrieve the transaction details.
 *  @param requestType The PBBA API request type.
 *
 *  @return YES if the process of hand-off to CFI app was successful.
 */
+ (BOOL)openBankingApp:(nonnull NSString *)secureToken
           requestType:(PBBARequestType)requestType
            NS_SWIFT_NAME(openBankingApp(secureToken:requestType:));

/**
 *  Show PBBA popup view controller.
 *
 *  It opens the CFI app automatically (without displaying the popup) if the device has CFI app installed and the user has tapped 'Open banking app' button.
 *  Before opening the CFI app automatically it will also close any instance of error PBBAPopupViewController which is presented.
 *
 *  @param presenter      The presenter controller which will present the popup view controller.
 *  @param secureToken    The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn            The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *  @param expiryInterval The time interval defined by the zapp core in order to confirm the payment.
 *  @param requestType The PBBA API request type.
 *  @param delegate    The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController which has been presented.
 */

+ (nullable PBBAPopupViewController *)showPBBAPopup:(nonnull UIViewController *)presenter
                                        secureToken:(nonnull NSString *)secureToken
                                                brn:(nonnull NSString *)brn
                                     expiryInterval:(NSUInteger) expiryInterval
                                        requestType:(PBBARequestType)requestType
                                           delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate
                                            NS_SWIFT_NAME(showPBBAPopup(presenter:secureToken:brn:requestType:delegate:));

/**
 *  Show PBBA error popup view controller.
 *
 *  @param presenter    The presenter controller which will present the popup view controller.
 *  @param errorCode    The error code to be displayed inside the popup.
 *  @param errorTitle   The error title to be displayed inside the popup.
 *  @param errorMessage The error message to be displayed inside the popup.
 *  @param delegate     The popup view controller delegate.
 *
 *  @return An instance of PBBAPopupViewController which has been presented.
 */
+ (nullable PBBAPopupViewController *)showPBBAErrorPopup:(nonnull UIViewController *)presenter
                                               errorCode:(nullable NSString *)errorCode
                                              errorTitle:(nullable NSString *)errorTitle
                                            errorMessage:(nonnull NSString *)errorMessage
                                                delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate
                                                NS_SWIFT_NAME(showPBBAErrorPopup(presenter:errorCode:errorTitle:errorMessage:delegate:));
/**
 *  Show PBBA More About popup view controller.
 *
 *  It opens the "More about PBBA" popup, containing bank logos
 *
 *  @param presenter       The presenter controller which will present the popup view controller.
 *  @param logosService    The logos service which will provide the popup with bank logos.
 *
 *  @return An instance of PBBAMoreAboutViewController which has been presented.
 */
+ (nullable PBBAPopupViewController *)showPBBAMoreAboutPopup:(nonnull UIViewController *)presenter
                                            withLogosService:(PBBABankLogosService*) logosService

NS_SWIFT_NAME(showPBBAMoreAboutPopup(presenter:withLogosService:));


typedef enum {
    PBBACustomButtonTypeMoreAboutAndBankLogos, // link and bank logos
    PBBACustomButtonTypeBankLogos,// only bank logos
    PBBACustomButtonTypeMoreAbout, // only link
    PBBACustomButtonTypeNone, // custom design
} PBBACustomUXType;

/**
 *  API to get PBBA integrated button component.
 *
 *  @param width for integrated button.
 *  @param customUXType PBBACustomUXType enum for CustomUXType.
 *  @return UIVIew instance based on the configurations for PBBA branding logo
 *   cfi logos and More About button.
 */
+(UIView*)getCustomUXConfigurationsWithWidth:(CGFloat)width andType:(PBBACustomUXType)customUXType;

@end

@interface PBBAAppUtils (Deprecated)

/**
 *  Check if at least one PBBA enabled CFI app is installed on the current device.
 *
 *  @note You must whitelist first the 'zapp' scheme in your Info.plist file under the LSApplicationQueriesSchemes key.
 *  @warning This method is deprecated. Please use `+[PBBAAppUtils isCFIAppAvailableForRequestType:]` method instead.
 *
 *  @return YES if CFI app is installed.
 */
+ (BOOL)isCFIAppAvailable DEPRECATED_MSG_ATTRIBUTE("Please use 'isCFIAppAvailableForRequestType:' method instead.");

/**
 *  Open the PBBA enabled CFI app.
 *
 *  @param secureToken The secure token to retrieve the transaction details.
 *
 *  @warning This method is deprecated. Please use `+[PBBAAppUtils openBankingApp:requestType:]` method instead.
 *
 *  @return YES if the process of hand-off to CFI app was successful.
 */
+ (BOOL)openBankingApp:(nonnull NSString *)secureToken
    NS_SWIFT_NAME(openBankingApp(secureToken:))
    DEPRECATED_MSG_ATTRIBUTE("Please use 'openBankingApp:requestType:' method instead.");

/**
 *  Show PBBA popup view controller.
 *
 *  It opens the CFI app automatically (without displaying the popup) if the device has CFI app installed and the user has tapped 'Open banking app' button.
 *  Before opening the CFI app automatically it will also close any instance of error PBBAPopupViewController which is presented.
 *
 *  @param presenter   The presenter controller which will present the popup view controller.
 *  @param secureToken The human friendly transaction retrieval identifier issued by Zapp.
 *  @param brn         The Basket Reference Number for entry in the CFI app on the consumer’s device.
 *  @param delegate    The popup view controller delegate.
 *
 *  @warning This method is deprecated. Please use `+[PBBAAppUtils showPBBAPopup:secureToken:brn:requestType:delegate:]` method instead.
 *
 *  @return An instance of PBBAPopupViewController which has been presented.
 */
+ (nullable PBBAPopupViewController *)showPBBAPopup:(nonnull UIViewController *)presenter
                                        secureToken:(nonnull NSString *)secureToken
                                                brn:(nonnull NSString *)brn
                                           delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate
                                            NS_SWIFT_NAME(showPBBAPopup(presenter:secureToken:brn:delegate:))
                                            DEPRECATED_MSG_ATTRIBUTE("Please use 'showPBBAPopup:secureToken:brn:requestType:delegate:' method instead.");

@end
