//
//  PBBAPopupContentViewController.m
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
#import "NSBundle+ZPMLib.h"
#import "UIView+ZPMLib.h"
#import "PBBACodeView.h"
#import "PBBAErrorView.h"
#import "NSError+ZPMLib.h"
#import "PBBAExpiryTimer.h"
#import "UIFont+ZPMLib.h"
#import "UIColor+ZPMLib.h"
#import "NSAttributedString+ZPMLib.h"
#import "PBBABankLogosContainer.h"
#import "UIImage+ZPMLib.h"

typedef enum {
    ContainingPopupLayoutTypeNone,
    ContainingPopupLayoutTypeError,
    ContainingPopupLayoutTypeECom
} ContainingPopupLayoutType;


@interface PBBAPopupContentViewController () <PBBACodeViewProtocol,PBBAErrorViewProtocol>
/**
 *  The expiration interval to be shown in the popup
 */
@property (nonatomic) NSUInteger expiryInterval;

@property (weak, nonatomic) IBOutlet UILabel *eComAdviceLabel;
@property (assign, nonatomic) ContainingPopupLayoutType currentType;
@property (nonatomic, weak) IBOutlet UIView *currentView;
@property (strong,nonatomic) PBBAExpiryTimer* timer;
@property (weak, nonatomic) IBOutlet PBBABankLogosContainer *logosView;

@property (weak, nonatomic) IBOutlet UILabel *step1Label;
@property (weak, nonatomic) IBOutlet UILabel *step2Label;
@property (weak, nonatomic) IBOutlet UILabel *step3Label;
@property (weak, nonatomic) IBOutlet UIImageView *step3ImageView;

@property (nonatomic, weak) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *step1HolderView;
@property (weak, nonatomic) IBOutlet UIView *step2HolderView;
@property (weak, nonatomic) IBOutlet UIView *step3HolderView;

@end

@implementation PBBAPopupContentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:[NSBundle pbba_merchantResourceBundle]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float fontSize = 14.0f;
    
    //  Step 1
    NSString *coloredFragment1 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep1Colored");
    NSAttributedString *step1Text = [NSAttributedString pbba_highlightByFontFragment:@""
                                                                     byColorFragment:coloredFragment1
                                                                            inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep1")
                                                                            withFont:[UIFont pbba_regularFontWithSize:fontSize]
                                                                      hightlightFont:[UIFont pbba_mediumFontWithSize:fontSize]
                                                                      highlightColor:[UIColor pbba_pbbaBrandColor]
                                                                           alignment:NSTextAlignmentCenter];

    self.step1Label.attributedText = step1Text;
    [self adjustFontSizeFor:self.step1Label];

    // Step 2
    NSString *coloredFragment2 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2Colored");
    NSString *boldFragment2 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2Bold");
    NSAttributedString *step2Text = [NSAttributedString pbba_highlightByFontFragment:boldFragment2
                                                                     byColorFragment:coloredFragment2                                                                              inText:PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2")
                                                                            withFont:[UIFont pbba_regularFontWithSize:fontSize]
                                                                      hightlightFont:[UIFont pbba_mediumFontWithSize:fontSize]
                                                                      highlightColor:[UIColor pbba_pbbaBrandColor]
                                                                           alignment:NSTextAlignmentCenter];
    self.step2Label.attributedText = step2Text;
    [self adjustFontSizeFor:self.step2Label];

    NSString *inTextString = @"";
    if (self.popupCoordinator.requestType == PBBARequestTypeRequestToLink) {
        inTextString = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep3LinkOnly");
    } else {
        inTextString =  PBBALocalizedString(@"com.zapp.view.codeInstructionsStep3");
    }
    // Step 3
    NSString *coloredFragment3 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep3Colored");
    NSAttributedString *step3Text = [NSAttributedString pbba_highlightByFontFragment:@""
                                                                     byColorFragment:coloredFragment3                                                                              inText:inTextString
                                                                            withFont:[UIFont pbba_regularFontWithSize:fontSize]
                                                                      hightlightFont:[UIFont pbba_mediumFontWithSize:fontSize]
                                                                      highlightColor:[UIColor pbba_pbbaBrandColor]
                                                                           alignment:NSTextAlignmentCenter];
    self.step3Label.attributedText = step3Text;
    [self adjustFontSizeFor:self.step3Label];
    [self updateImageForDeviceOrientation];
    
    [self.logosView setLogosService: self.popupCoordinator.logosService];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    [self updateCurrentView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setContentOffset:self.topView.bounds.origin];

    if (@available(iOS 11, *))
    {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        self.topView.frame = guide.layoutFrame;
    }
    self.step1HolderView.shouldGroupAccessibilityChildren = self.step2HolderView.shouldGroupAccessibilityChildren = YES;
    if (_step3Label && _step3ImageView && _contentView) {
        self.step3HolderView.accessibilityElements = @[_step3ImageView,_step3Label,_contentView];
    }

}

-(void)adjustFontSizeFor:(UILabel*)label
{
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.minimumFontSize = 10;
    label.lineBreakMode = UILineBreakModeClip;
}

-(void)setStepTwoLabelText:(NSString*)Identifier
{
    float fontSize = 14.0f;

    NSString *coloredFragment2 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2Colored");
    NSString *boldFragment2 = PBBALocalizedString(@"com.zapp.view.codeInstructionsStep2Bold");
    NSAttributedString *step2Text = [NSAttributedString pbba_highlightByFontFragment:boldFragment2
                                                                     byColorFragment:coloredFragment2                                                                              inText:PBBALocalizedString(Identifier)
                                                                            withFont:[UIFont pbba_regularFontWithSize:fontSize]
                                                                      hightlightFont:[UIFont pbba_mediumFontWithSize:fontSize]
                                                                      highlightColor:[UIColor pbba_pbbaBrandColor]
                                                                           alignment:NSTextAlignmentCenter];
    self.step2Label.attributedText = step2Text;
    [self adjustFontSizeFor:self.step2Label];
    self.step2Label.minimumFontSize = 12;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (size.width > size.height)
        {
            _step3ImageView.image = [UIImage pbba_imageNamed:@"artwork_step_3_Landscape"];
            [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.landscape"];
        }
        else
        {
            [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.portrait"];
            _step3ImageView.image = [UIImage pbba_imageNamed:@"artwork_step_3_code_svg"];
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.landscape"];
    }
}

-(void)updateImageForDeviceOrientation
{
     UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _step3ImageView.image = [UIImage pbba_imageNamed:@"artwork_step_3_Landscape"];
    [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.landscape"];
    }
    else
    {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationLandscapeRight) | (statusBarOrientation == UIInterfaceOrientationLandscapeLeft)) {
               [self.scrollView setContentOffset:CGPointMake(-10, 0)];
            [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.landscape"];
            _step3ImageView.image = [UIImage pbba_imageNamed:@"artwork_step_3_Landscape"];
        }
        else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationPortrait)) {
            [self setStepTwoLabelText:@"com.zapp.view.codeInstructionsStep2.portrait"];
            _step3ImageView.image = [UIImage pbba_imageNamed:@"artwork_step_3_code_svg"];
        }
    }
}

- (void) updateCurrentView
{
    if (self.contentView)
    {
        [_contentView addSubview:self.currentView];
        [self.currentView pbba_pinToSuperviewEdges];
        _eComAdviceLabel.hidden = _currentType == ContainingPopupLayoutTypeError;
        [self.scrollView setContentOffset:self.topView.bounds.origin];
    }
}

- (void) updateForBRN: (NSString*) brn
    andExpiryInterval: (NSInteger) expiryInterval
{
    if (_currentType == ContainingPopupLayoutTypeECom) return;
    _currentType = ContainingPopupLayoutTypeECom;
    
    PBBACodeView* codeView = [[PBBACodeView alloc] initWithBRN:brn
                                             andExpiryInterval:expiryInterval];
    codeView.subscriber = self;
    [self updateFor:codeView];
    
    
}

- (void) updateForError:(NSError *)error
{
    if (_currentType == ContainingPopupLayoutTypeError) return;
    _currentType = ContainingPopupLayoutTypeError;
    
    PBBAErrorView* errorView = [[PBBAErrorView alloc] initWithError:error];
    errorView.subscriber = self;
    [self updateFor:errorView];
    
}

- (void) updateFor: (UIView*) viewToAdd
{
    [_contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    
    self.currentView = viewToAdd;
    [self updateCurrentView];
}




- (void)codeViewExpired {
     [self.popupCoordinator setPopupExpired];
}


- (void) errorViewRetry {
    [self.popupCoordinator retryPaymentRequest];
}

#pragma mark - Scroll View delegates
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationLandscapeRight) | (statusBarOrientation == UIInterfaceOrientationLandscapeLeft)) {
        [self.scrollView setContentOffset:CGPointMake(-5, 0)];
    }
    return self.topView;
}


@end
