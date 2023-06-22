//
//  PBBAPopupViewController.m
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

#import "PBBAPopupViewController.h"
#import "PBBAPopupScaleAspectFitAnimationContext.h"
#import "UIView+ZPMLib.h"
#import "NSBundle+ZPMLib.h"
#import "PBBAMoreAboutViewController.h"
#import "PBBAErrorView.h"
#import "PBBAMComViewController.h"
#import "NSError+ZPMLib.h"

@interface PBBAPopupViewController () <UIViewControllerTransitioningDelegate, PBBAPopupCoordinatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *footerMCLogo;
@property (weak, nonatomic) IBOutlet UIImageView *headerPBBALogo;

@end

@implementation PBBAPopupViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (IBAction)didPressCloseButton:(id)sender{
    [self.popupCoordinator closePopupAnimated:YES
                                        initiator:PBBAPopupCloseActionInitiatorUser
                                       completion:nil];
}

/*
 3.1 code
- (void)setSecureToken:(NSString *)secureToken
                        brn:(NSString *)brn
                   delegate:(id<PBBAPopupViewControllerDelegate>)delegate
*/
- (void)setSecureToken:(NSString *)secureToken
                                brn:(NSString *)brn
                        requestType:(PBBARequestType)requestType
                           delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
        self.delegate = delegate;
        self.popupCoordinator = [[PBBAPopupCoordinator alloc] initWithSecureToken:secureToken
                                                                              brn:brn
                                                                      requestType:requestType];
        self.popupCoordinator.delegate = self;
}

- (void)setErrorCode:(NSString *)errorCode
               errorTitle:(NSString *)errorTitle
             errorMessage:(NSString *)errorMessage
                 delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
        self.delegate = delegate;
        self.popupCoordinator = [[PBBAPopupCoordinator alloc] initWithErrorCode:errorCode
                                                                     errorTitle:errorTitle
                                                                   errorMessage:errorMessage];
        self.popupCoordinator.delegate = self;
}

- (void)updateSecureToken:(NSString *)secureToken
                          brn:(NSString *)brn
{
    self.popupCoordinator.secureToken = secureToken;
    self.popupCoordinator.brn = brn;
    [self.popupCoordinator updateLayout];
}

- (void)updateErrorCode:(NSString *)errorCode
                 errorTitle:(NSString *)errorTitle
               errorMessage:(NSString *)errorMessage
{
    self.popupCoordinator.secureToken = nil;
    self.popupCoordinator.brn = nil;
    
    self.popupCoordinator.errorCode = errorCode;
    self.popupCoordinator.errorTitle = errorTitle;
    self.popupCoordinator.errorMessage = errorMessage;
    
    [self.popupCoordinator updateLayout];
}
- (void)updateForMoreAboutWithBankLogosService: (PBBABankLogosService*) logosService {
    if (!self.popupCoordinator) {
        self.popupCoordinator = [PBBAPopupCoordinator new];
        self.popupCoordinator.delegate = self;
        self.popupCoordinator.logosService = logosService;
    }
    [self.popupCoordinator updateToMoreAboutLayout];
}

#pragma mark - Accessors

- (NSString *)secureToken
{
    return self.popupCoordinator.secureToken;
}

- (NSString *)brn
{
    return self.popupCoordinator.brn;
}

- (NSString *)errorCode
{
    return self.popupCoordinator.errorCode;
}

- (NSString *)errorTitle
{
    return self.popupCoordinator.errorTitle;
}

- (NSString *)errorMessage
{
    return self.popupCoordinator.errorMessage;
}

#pragma mark - VC Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure main view
    self.containerViewController = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupContainerController"];
    self.footerMCLogo.accessibilityValue = @"image";
    self.headerPBBALogo.accessibilityValue = @"image";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerWillAppear:)]) {
        [self.delegate pbbaPopupViewControllerWillAppear:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addChildViewController:self.containerViewController];
    [self.containerView addSubview:self.containerViewController.view];
    CGRect frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerViewController.view setFrame:frame];
    [self.containerViewController didMoveToParentViewController:self];
    [self.popupCoordinator updateLayout];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidAppear:)]) {
        [self.delegate pbbaPopupViewControllerDidAppear:self];
    }
    if (@available(iOS 11, *))
    {
            UILayoutGuide *guide = self.containerViewController.view.safeAreaLayoutGuide;
            self.containerViewController.activeViewController.view.frame = guide.layoutFrame;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerWillDisappear:)]) {
        [self.delegate pbbaPopupViewControllerWillDisappear:self];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidDisappear:)]) {
        [self.delegate pbbaPopupViewControllerDidDisappear:self];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
     self.containerViewController.activeViewController.view.hidden = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerViewController.view setFrame:frame];
    [self.containerViewController.activeViewController.view setFrame:frame];
    self.containerViewController.activeViewController.view.hidden = NO;
    if (@available(iOS 11, *))
    {
        UILayoutGuide *guide = self.containerViewController.view.safeAreaLayoutGuide;
        self.containerViewController.activeViewController.view.frame = guide.layoutFrame;
    }
}

-(id)instantiateControllerFromStoryboard:(NSString*)storyboard forIdentifier:(NSString*)identifier
{
    UIStoryboard *storyboardInstance = [UIStoryboard storyboardWithName:storyboard
                                                                 bundle:[NSBundle pbba_merchantResourceBundle]];
    return [storyboardInstance instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark - ZPMPopupCoordinatorDelegate

-(void)popupCoordinatorPopupDidExpire:(PBBAPopupCoordinator *)coordinator {
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidExpire:)]) {
        [self.delegate pbbaPopupViewControllerDidExpire:self];
    }
}

- (void)popupCoordinatorRetryPaymentRequest:(PBBAPopupCoordinator *)coordinator
{
    if ([self.delegate respondsToSelector:@selector(pbbaPopupViewControllerRetryPaymentRequest:)]) {
        [self.delegate pbbaPopupViewControllerRetryPaymentRequest:self];
    }
}

- (void)popupCoordinatorClosePopup:(PBBAPopupCoordinator *)coordinator
                         initiator:(PBBAPopupCloseActionInitiator)initiator
                          animated:(BOOL)animated
                        completion:(dispatch_block_t)completion
{
    if (initiator == PBBAPopupCloseActionInitiatorMComLayoutMoreAbout)
    {
        //update to previous layout
        //if the popup is launched from MComLayout
        [self popupCoordinatorUpdateToMComLayout:coordinator];
    }
    else
    {
        [self dismissViewControllerAnimated:animated completion:^{
            
            if (initiator == PBBAPopupCloseActionInitiatorUser &&
                [self.delegate respondsToSelector:@selector(pbbaPopupViewControllerDidCloseByUser:)]) {
                [self.delegate pbbaPopupViewControllerDidCloseByUser:self];
            }
            
            if (completion) completion();
        }];
    }
}

- (void)popupCoordinatorUpdateToMComLayout:(PBBAPopupCoordinator *)coordinator
{
    PBBAMComViewController *mComVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAMComViewController"];
    mComVC.popupCoordinator = coordinator;
    mComVC.brn = self.brn;
    [self.containerViewController pushViewController:mComVC];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
}

- (void)popupCoordinator:(PBBAPopupCoordinator *)coordinator updateToEComLayout:(PBBAPopupEComLayoutType)ecomLayout
{
    PBBAPopupContentViewController *eComVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupContentViewController"];
    eComVC.popupCoordinator = coordinator;
    [eComVC updateForBRN:self.brn andExpiryInterval: self.expiryInterval];
    [self.containerViewController pushViewController:eComVC];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
}

- (void)popupCoordinatorUpdateToErrorLayout:(PBBAPopupCoordinator *)coordinator
                                 errorTitle:(NSString *)title
                               errorMessage:(NSString *)message
{
    PBBAPopupContentViewController *errorVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAPopupContentViewController"];
    errorVC.popupCoordinator = coordinator;
    [errorVC updateForError:[NSError errorWithCode:self.errorCode
                                             Title:self.errorTitle
                                        andMessage:self.errorMessage]];
    [self.containerViewController pushViewController:errorVC];
}

- (void)popupCoordinatorUpdateToMoreAboutLayout:(PBBAPopupCoordinator *)coordinator
{
    PBBAMoreAboutViewController *moreAboutVC = [self instantiateControllerFromStoryboard:@"PBBAPopup" forIdentifier:@"PBBAMoreAboutViewController"];
    moreAboutVC.popupCoordinator = coordinator;
    [self.containerViewController pushViewController:moreAboutVC];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
}

@end

