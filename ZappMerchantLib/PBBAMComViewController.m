//
//  PBBAMComViewController.m
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

#import "PBBAMComViewController.h"
#import "PBBAPopupButton.h"
#import "PBBALibraryUtils.h"
#import "PBBAButton.h"
#import "NSBundle+ZPMLib.h"
#import "PBBAAppUtils.h"

@interface PBBAMComViewController ()

@property (weak, nonatomic) IBOutlet PBBAPopupButton *openBankingAppButton;
@property (weak, nonatomic) IBOutlet PBBAPopupButton *getZappCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *openBankingAppTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *openBankingAppMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *getZappCodeMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *getZappCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeInstructionsTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *openBankAppHolderView;
@property (weak, nonatomic) IBOutlet UIView *getCodeHolderView;

@end

@implementation PBBAMComViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    self.openBankingAppTitle = PBBALocalizedString(@"com.zapp.mcom.openBankAppTitle");
    self.openBankingAppMessage = PBBALocalizedString(@"com.zapp.mcom.openBankAppMessage");
    self.openBankingAppButtonTitle = PBBALocalizedString(@"com.zapp.mcom.openBankAppButtonTitle");
    
    if (self.getZappCodeTitleLabel) {
        self.getZappCodeTitle = PBBALocalizedString(@"com.zapp.mcom.getZappCodeTitle");
        self.getZappCodeMessage = PBBALocalizedString(@"com.zapp.mcom.getZappCodeMessage");
    }
    
    _getZappCodeButton.tintColor = [UIColor blackColor];
    [self.scrollView setContentOffset:self.topView.bounds.origin];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.openBankAppHolderView.shouldGroupAccessibilityChildren = self.getCodeHolderView.shouldGroupAccessibilityChildren = YES;

}
- (IBAction)openMoreAbout:(id)sender
{
    [self.popupCoordinator updateToMoreAboutLayout];
}


- (NSString *)openBankingAppTitle
{
    return self.openBankingAppTitleLabel.text;
}

- (void)setOpenBankingAppTitle:(NSString *)title
{
    self.openBankingAppTitleLabel.text = title;
}

- (NSString *)openBankingAppMessage
{
    return self.openBankingAppMessageLabel.text;
}

- (NSString *)openBankingAppButtonTitle
{
    return [self.openBankingAppButton titleForState:UIControlStateNormal];
}

- (void)setOpenBankingAppButtonTitle:(NSString *)title
{
    [self.openBankingAppButton setTitle:title forState:UIControlStateNormal];
}

- (NSString *)getZappCodeTitle
{
    return self.getZappCodeTitleLabel.text;
}

- (void)setGetZappCodeTitle:(NSString *)title
{
    self.getZappCodeTitleLabel.text = title;
}

- (NSString *)getZappCodeMessage
{
    return self.getZappCodeMessageLabel.text;
}

- (void)setGetZappCodeMessage:(NSString *)message
{
    self.getZappCodeMessageLabel.text = message;
}


#pragma mark - Actions

- (IBAction)didPressOpenBankingApp:(id)sender
{
    [self.popupCoordinator closePopupAnimated:YES
                                    initiator:PBBAPopupCloseActionInitiatorSelf
                                   completion:^{
                                       [self.popupCoordinator registerCFIAppLaunch];
                                       [self.popupCoordinator openAppPicker:self.popupCoordinator.secureToken requestType:self.popupCoordinator.requestType brn:self.popupCoordinator.brn expiryInterval:self.popupCoordinator.expiryInterval presenter:self.popupCoordinator.presenter];
                                   }];
}

- (IBAction)didPressGetZappCode:(id)sender
{
    [self.popupCoordinator updateToLayout:PBBAPopupLayoutTypeECom];
}

#pragma mark - Scroll View delegates
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.topView;
}
@end

