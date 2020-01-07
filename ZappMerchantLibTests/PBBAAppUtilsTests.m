//
//  PBBAAppUtilsTests.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 7/8/16.
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

#import "PBBATestEnvironment.h"

SPEC_BEGIN(PBBAAppUtilsTests)

describe(@"For PBBAAppUtils class", ^{
    
    NSString *testString = @"This is a test string";
    NSString *validBRN = @"ABCABC";
    NSString *validSecureToken = @"123456789";
    NSInteger validExpiryInterval = 250.0;
         
    UIViewController *validPresenter = [UIViewController new];
    PBBAPopupViewController *validPopupVC = [PBBAPopupViewController new];
    
    __block UIViewController *mockPresenter;
    __block PBBAPopupViewController *mockPBBAPopupViewController;
    
    beforeEach(^{
        mockPresenter = [UIViewController mock];
        mockPBBAPopupViewController = [PBBAPopupViewController mock];
        
        // Stub popup initialisation
        [PBBAPopupViewController stub:@selector(alloc) andReturn:mockPBBAPopupViewController];
        [mockPBBAPopupViewController stub:@selector(init) andReturn:mockPBBAPopupViewController];
    [mockPBBAPopupViewController stub:@selector(showPBBAPopup:secureToken:brn:expiryInterval:requestType:delegate:) andReturn:mockPBBAPopupViewController];
        
        // Stub error popup initialisation
    [mockPBBAPopupViewController stub:@selector(showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate:) andReturn:mockPBBAPopupViewController];
    });
    
    it(@"a call to isCFIAppAvailableForRequestType should return YES if there is a PBBA enabled CFI app", ^{
        
        [[PBBALibraryUtils should] receive:@selector(isCFIAppAvailableForRequestType:) andReturn:theValue(YES)];
        
        [[theValue([PBBAAppUtils isCFIAppAvailableForRequestType:PBBARequestTypeRequestToPay]) should] beYes];
    });
    
    it(@"a call to openBankingApp: should assert for nil secureToken", ^{
        
        [[theBlock(^{
            [PBBAAppUtils openBankingApp:nil requestType:PBBARequestTypeRequestToPay];
        }) should] raise];
    });
    
    it(@"a call to openBankingApp: should succeed for valid secureToken", ^{
        
        [[PBBALibraryUtils should] receive:@selector(openBankingApp:requestType:) andReturn:theValue(YES)];
        
         [[theValue([PBBAAppUtils openBankingApp:validSecureToken requestType:PBBARequestTypeRequestToPay]) should] beYes];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should assert for nil presenter", ^{
        
        [[theBlock(^{
            [PBBAAppUtils showPBBAPopup:nil secureToken:validSecureToken brn:validBRN expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
        }) should] raise];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should assert for nil secureToken", ^{
        
        [[theBlock(^{
           [PBBAAppUtils showPBBAPopup:validPresenter secureToken:nil brn:validBRN expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
        }) should] raise];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should assert for nil BRN", ^{
        
        [[theBlock(^{
         [PBBAAppUtils showPBBAPopup:validPresenter secureToken:validSecureToken brn:nil expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
        }) should] raise];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should assert for BRN with invalid length", ^{
        
        [[theBlock(^{
 [PBBAAppUtils showPBBAPopup:validPresenter secureToken:validSecureToken brn:@"ABC" expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
            
        }) should] raise];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should succeed for valid parameters", ^{
        
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:nil withCount:2];
        [[mockPresenter should] receive:@selector(presentViewController:animated:completion:) withArguments:mockPBBAPopupViewController, any(), any()];
        
     [PBBAAppUtils showPBBAPopup:validPresenter secureToken:validSecureToken brn:validBRN expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should update the presented popup for valid parameters", ^{

        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:validPopupVC withCount:2];
        [[mockPresenter shouldNot] receive:@selector(presentViewController:animated:completion:)];

    PBBAPopupViewController *presentedVC = [PBBAAppUtils showPBBAPopup:mockPresenter secureToken:validSecureToken brn:validBRN expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];

        [[presentedVC should] equal:validPopupVC];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should not present PBBA popup if there is already presented something", ^{
        
        [[mockPresenter should] receive:@selector(presentViewController:animated:completion:) withArguments:mockPBBAPopupViewController, any(), any()];
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:validPresenter withCount:2];
        
    PBBAPopupViewController *presentedVC = [PBBAAppUtils showPBBAPopup:mockPresenter secureToken:validSecureToken brn:validBRN expiryInterval:validExpiryInterval requestType:PBBARequestTypeRequestToPay delegate:nil];
        
        [[presentedVC should] beNil];
    });
    
    it(@"a call to showPBBAPopup:secureToken:brn:delegate: should invoke CFI app instead of presenting PBBA popup", ^{
        
        [[PBBALibraryUtils should] receive:@selector(shouldLaunchCFIAppForRequestType:) andReturn:theValue(YES)];
        [[PBBALibraryUtils should] receive:@selector(openBankingApp:requestType:) andReturn:theValue(YES)];
        
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:mockPBBAPopupViewController];
        [[mockPresenter should] receive:@selector(dismissViewControllerAnimated:completion:)];
        [[mockPresenter shouldNot] receive:@selector(presentViewController:animated:completion:) withArguments:mockPBBAPopupViewController, any(), any()];
        
        PBBAPopupViewController *presentedVC = [PBBAAppUtils showPBBAPopup:mockPresenter
                                                               secureToken:validSecureToken
                                                                       brn:validBRN expiryInterval:validExpiryInterval
                                            requestType:PBBARequestTypeRequestToPay
                                                                  delegate:nil];
        
        [[presentedVC should] beNil];
    });
    
    it(@"a call to showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate: should assert for nil presenter", ^{
        
        [[theBlock(^{
            [PBBAAppUtils showPBBAErrorPopup:nil errorCode:testString errorTitle:testString errorMessage:testString delegate:nil];
        }) should] raise];
    });
    
    it(@"a call to showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate: should assert for nil errorMessage", ^{
        
        [[theBlock(^{
            [PBBAAppUtils showPBBAErrorPopup:nil errorCode:testString errorTitle:testString errorMessage:nil delegate:nil];
        }) should] raise];
    });
    
    it(@"a call to showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate: should succeed for valid parameters", ^{
        
        [[mockPresenter should] receive:@selector(presentViewController:animated:completion:) withArguments:mockPBBAPopupViewController, any(), any()];
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:validPresenter withCount:2];

        [PBBAAppUtils showPBBAErrorPopup:validPresenter errorCode:testString errorTitle:testString errorMessage:testString delegate:nil];
    });
    
    it(@"a call to showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate: should update the presented popup for valid parameters", ^{
        
        [[mockPresenter shouldNot] receive:@selector(presentViewController:animated:completion:)];
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:validPopupVC withCount:2];
        
        PBBAPopupViewController *presentedVC = [PBBAAppUtils showPBBAErrorPopup:validPresenter
                                                                      errorCode:testString
                                                                     errorTitle:testString
                                                                   errorMessage:testString
                                                                       delegate:nil];
        
        [[presentedVC should] equal:validPopupVC];
    });
    
    it(@"a call to showPBBAErrorPopup:errorCode:errorTitle:errorMessage:delegate: should not present PBBA popup if there is already presented something", ^{
        
        [[mockPresenter should] receive:@selector(presentViewController:animated:completion:) withArguments:mockPBBAPopupViewController, any(), any()];
        [[mockPresenter should] receive:@selector(presentedViewController) andReturn:validPresenter withCount:2];
        
        PBBAPopupViewController *presentedVC = [PBBAAppUtils showPBBAErrorPopup:mockPresenter errorCode:testString errorTitle:testString errorMessage:testString delegate:nil];
        
        [[presentedVC should] beNil];
    });
});

SPEC_END
