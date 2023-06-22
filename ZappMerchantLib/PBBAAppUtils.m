//
//  PBBAAppUtils.m
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

#import "PBBAAppUtils.h"
#import "PBBALibraryUtils.h"
#import "UIImage+ZPMLib.h"
#import "PBBABankLogosService.h"
#import "PBBAExpiryTimer.h"
#import "NSBundle+ZPMLib.h"
#import "PBBABankLogo.h"
#import "PBBACustomButton.h"
#import "PBBAMoreAboutViewController.h"
#import "PBBACustomUXConfig.h"

@implementation PBBAAppUtils

//+ (BOOL)isCFIAppAvailable
//{
//    return [self isCFIAppAvailableForRequestType:PBBARequestTypeRequestToPay];
//}

+ (BOOL)isCFIAppAvailableForRequestType:(PBBARequestType)requestType
{
    return [PBBALibraryUtils isCFIAppAvailableForRequestType:requestType];
}

//+ (BOOL)openBankingApp:(NSString *)secureToken
//{
//    return [self openBankingApp:secureToken
//                    requestType:PBBARequestTypeRequestToPay];
//}

//+ (BOOL)openBankingApp:(NSString *)secureToken
//           requestType:(PBBARequestType)requestType
//{
//    NSAssert(secureToken, @"[PBBAAppUtils] 'secureToken' is a mandatory parameter.");
//
//    return [PBBALibraryUtils openBankingApp:secureToken requestType:requestType];
//}

//+ (PBBAPopupViewController *)showPBBAPopup:(UIViewController *)presenter
//                               secureToken:(NSString *)secureToken
//                                       brn:(NSString *)brn
//                                  delegate:(id<PBBAPopupViewControllerDelegate>)delegate
//{
//    return [self showPBBAPopup:presenter
//                   secureToken:secureToken
//                           brn:brn
//                   requestType:PBBARequestTypeRequestToPay
//                      delegate:delegate];
//}

//+ (nullable PBBAPopupViewController *)showPBBAPopup:(nonnull UIViewController *)presenter
//                                        secureToken:(nonnull NSString *)secureToken
//                                                brn:(nonnull NSString *)brn
//                                           delegate:(nullable id<PBBAPopupViewControllerDelegate>)delegate {
//    return [self showPBBAPopup:presenter
//                   secureToken:secureToken
//                           brn:brn
//                expiryInterval:0
//                      delegate:delegate];
//}

+(id)instantiateControllerFromStoryboard:(NSString*)storyboard forIdentifier:(NSString*)identifier
{
    UIStoryboard *storyboardInstance = [UIStoryboard storyboardWithName:storyboard
                                                         bundle:[NSBundle pbba_merchantResourceBundle]];
    return [storyboardInstance instantiateViewControllerWithIdentifier:identifier];
}


+ (nullable PBBAPopupViewController *)showPBBAPopup:(nonnull UIViewController *)presenter
                                        secureToken:(nonnull NSString *)secureToken
                                                brn:(nonnull NSString *)brn
                                     expiryInterval:(NSUInteger ) expiryInterval
                                        requestType:(PBBARequestType)requestType
                                           delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    NSAssert(presenter, @"[PBBAAppUtils] 'presenter' is a mandatory parameter.");
    NSAssert(secureToken, @"[PBBAAppUtils] 'secureToken' is a mandatory parameter.");
    NSAssert(brn, @"[PBBAAppUtils] 'brn' is a mandatory parameter.");
    NSAssert(brn.length == 6, @"[PBBAAppUtils] 'brn' length must be 6 characters.");
    
    if ([PBBALibraryUtils shouldLaunchCFIAppForRequestType:requestType]) {
        
        // Dismiss any instance of the presented PBBAPopupViewController before opening the CFI app
        if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
            [presenter dismissViewControllerAnimated:NO completion:nil];
        }
        
        // Launch CFI app and exit early
        [PBBALibraryUtils openAppPicker:secureToken requestType:requestType brn:brn expiryInterval:expiryInterval presenter:presenter];
        return nil;
    }
    // Update the already presented instance of PBBAPopupViewController instead of recreating it
    if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
        PBBAPopupViewController *pbbaPopupVC = (PBBAPopupViewController *) presenter.presentedViewController;
        [pbbaPopupVC updateSecureToken:secureToken
                                       brn:brn];
        
        pbbaPopupVC.delegate = delegate;
        
        // Exit early
        return pbbaPopupVC;
    }
    
    // Create a new instance of PBBAPopupViewController and try to present it
    PBBAPopupViewController *pbbaPopupVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupViewController"];
    pbbaPopupVC.expiryInterval = expiryInterval;
    [pbbaPopupVC setSecureToken:secureToken brn:brn requestType:requestType delegate:delegate];
    pbbaPopupVC.popupCoordinator.presenter = presenter;
    pbbaPopupVC.popupCoordinator.expiryInterval = expiryInterval;

/*
 TODO : add implementation for requestType param...
    // Create a new instance of PBBAPopupViewController and try to present it
    PBBAPopupViewController *pbbaPopupVC = [[PBBAPopupViewController alloc] initWithSecureToken:secureToken
                                                                                            brn:brn
                                                                                    requestType:requestType
                                                                                       delegate:delegate];
    */
    return [self presentPBBAPopup:pbbaPopupVC presenter:presenter];
}

+ (PBBAPopupViewController *)showPBBAErrorPopup:(UIViewController *)presenter
                                      errorCode:(NSString *)errorCode
                                     errorTitle:(NSString *)errorTitle
                                   errorMessage:(NSString *)errorMessage
                                       delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    NSAssert(presenter, @"[PBBAAppUtils] 'presenter' is a mandatory parameter.");
    NSAssert(errorMessage, @"[PBBAAppUtils] 'errorMessage' is a mandatory parameter.");
    
    // Update the already presented instance of PBBAPopupViewController instead of recreating it
    if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
        PBBAPopupViewController *pbbaPopupVC = (PBBAPopupViewController *) presenter.presentedViewController;
        [pbbaPopupVC updateErrorCode:errorCode
                              errorTitle:errorTitle
                            errorMessage:errorMessage];
        
        pbbaPopupVC.delegate = delegate;
        
        // Exit early
        return pbbaPopupVC;
    }
    
    PBBAPopupViewController *pbbaPopupVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupViewController"];
    [pbbaPopupVC setErrorCode:errorCode errorTitle:errorTitle errorMessage:errorMessage delegate:delegate];

    return [self presentPBBAPopup:pbbaPopupVC presenter:presenter];
}

+ (nullable PBBAPopupViewController *)showPBBAMoreAboutPopup:(nonnull UIViewController *)presenter
                                            withLogosService:(PBBABankLogosService*) logosService
{
    PBBAPopupViewController *pbbaPopupVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupViewController"];
    [pbbaPopupVC updateForMoreAboutWithBankLogosService:logosService];
    return [self presentPBBAPopup:pbbaPopupVC presenter:presenter];
}

+ (PBBAPopupViewController *)presentPBBAPopup:(PBBAPopupViewController *)pbbaPopupVC
                                    presenter:(UIViewController *)presenter
{
    [presenter presentViewController:pbbaPopupVC animated:YES completion:nil];
    
    // Return nil if the attempt to present the PBBAPopupViewController has failed
    return (presenter.presentedViewController == pbbaPopupVC) ? pbbaPopupVC : nil;
}

+(UIView*)getCustomUXConfigurationsWithWidth:(CGFloat)width andType:(PBBACustomUXType)customUXType
{
   static PBBACustomButton *customButton;
    switch (customUXType)
    {
        case  PBBACustomButtonTypeNone:
            customButton = [[PBBACustomButton alloc] initWithFrame:CGRectMake(0, 0, width, 41)];
            break;
        case  PBBACustomButtonTypeBankLogos:
            customButton = [[PBBACustomButton alloc] initWithFrame:CGRectMake(0, 0, width, 171)];
            break;
        case  PBBACustomButtonTypeMoreAbout:
            customButton = [[PBBACustomButton alloc] initWithFrame:CGRectMake(0, 0, width, 89)];
            break;
        case  PBBACustomButtonTypeMoreAboutAndBankLogos:
            customButton = [[PBBACustomButton alloc] initWithFrame:CGRectMake(0, 0, width, 206)];
            break;
        default:
            customButton = [[PBBACustomButton alloc] initWithFrame:CGRectMake(0, 0, width, 41)];
            break;
    }
    [customButton setCustomUXConfigurationsForType:customUXType];
    return customButton;
}

+(NSArray*)getBankLogos
{
   PBBABankLogosService *logosService =  [[PBBABankLogosService alloc] initLogosServiceWithSuccessBlock:nil errorBlock:nil];
    return logosService.smallLogos;
}

@end
