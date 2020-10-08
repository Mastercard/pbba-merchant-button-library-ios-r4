//
//  PBBAButton.m
//  ZappMerchant
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

#import "PBBAButton.h"
#import "PBBABankLogosService.h"
#import "PBBAButtonMain.h"
#import "UIView+ZPMLib.h"
#import "UIFont+ZPMLib.h"
#import "NSBundle+ZPMLib.h"
#import "UIColor+ZPMLib.h"
#import "PBBAAppUtils.h"
#import "PBBALibraryUtils.h"

@interface PBBAButton () <PBBAButtonMainDelegate,PBBAPopupViewControllerDelegate>
@property (nonatomic, strong) PBBABankLogosService* logosService;
@property (nonatomic, strong) PBBAButtonMain *pbbaMainView;

@property (nonatomic, readonly) UIView *containerForPBBAView;

@end

@implementation PBBAButton
@synthesize pbbaMainView = _pbbaMainView,
containerForPBBAView = _containerForPBBAView;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}


#pragma mark - Setup

- (void)setup
{
    // Get logo URLs
//     if ([PBBALibraryUtils shouldShowCFILogos]) {
        self.logosService =  [[PBBABankLogosService alloc] initLogosServiceWithSuccessBlock:nil errorBlock:nil];
//     }
    
    // Setup Constraints
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerForPBBAView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Centrate the layout in the placeholder
    [self addSubview:self.containerForPBBAView];
    [self.containerForPBBAView pbba_width:self.containerForPBBAView.frame.size.width];
    [self.containerForPBBAView pbba_height:self.containerForPBBAView.frame.size.height];
    [self.containerForPBBAView pbba_centerInSuperview];
    
    // Setup font and text
    [self setupStyle];
    
    // Layout view
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void) setupStyle
{
    [self.containerForPBBAView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIView class]] && obj.tag == 1) {
            // Main button
            [obj addSubview:self.pbbaMainView];
            [self.pbbaMainView pbba_centerInSuperview];
        }
        
        
        // Font and text for details label under the button
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label =obj;
            [label setText: PBBALocalizedString(@"com.zapp.pbba.button.details")];
        }
        
        // Font and text for "More about" button
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* moreAboutButton = obj;
            [moreAboutButton setTitle:PBBALocalizedString(@"com.zapp.pbba.button.moreAbout") forState:UIControlStateNormal];
            [moreAboutButton addTarget:self action:@selector(openMoreAbout) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

-(void)setEnabled:(BOOL)enabled {
    [self.pbbaMainView setEnabled:enabled];
}

#pragma mark - Custom View Initialization

- (PBBAButtonMain *)pbbaMainView
{
    if (!_pbbaMainView) {
        _pbbaMainView = [[PBBAButtonMain alloc] initWithLogosService:self.logosService
                                                            delegate:self];
    };
    return _pbbaMainView;
}

- (UIView*) containerForPBBAView
{
    if (!_containerForPBBAView) {
        NSString* nibName = NSStringFromClass(self.class);
        NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
        NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
        
        if (nibPath) {
            NSArray* elements = [bundle loadNibNamed:nibName owner:nil options:nil];
            for (UIView* view in elements) {
                _containerForPBBAView = view;
                return _containerForPBBAView;
            }
        }
    }
    return _containerForPBBAView;
}

#pragma mark - IBActions

// More about button action

- (void)openMoreAbout
{
    [PBBAAppUtils showPBBAMoreAboutPopup:[UIApplication sharedApplication].keyWindow.rootViewController withLogosService:self.logosService];
}

// PBBAButtonMainDelegate protocol implementation

- (BOOL)notifyPbbaButtonDidPress {
    return ([self.delegate respondsToSelector:@selector(pbbaButtonDidPress:)] && [self.delegate pbbaButtonDidPress:self]);
}

#pragma mark - PBBAUIElementAppearance

//   Redirect all the UI costomization calls to the real button

@synthesize backgroundColor,
borderColor,
borderWidth,
cornerRadius,
foregroundColor,
secondaryForegroundColor;


-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [_pbbaMainView setBackgroundColor:backgroundColor];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    [_pbbaMainView setBorderColor:borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    [_pbbaMainView setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    [_pbbaMainView setCornerRadius:cornerRadius];
}

-(void)setForegroundColor:(UIColor *)foregroundColor
{
    [_pbbaMainView setForegroundColor:foregroundColor];
}

-(void)setSecondaryForegroundColor:(UIColor *)secondaryForegroundColor
{
    [_pbbaMainView setSecondaryForegroundColor:secondaryForegroundColor];
}

- (void)pbbaPopupViewControllerRetryPaymentRequest:(nonnull PBBAPopupViewController *)pbbaPopupViewController {
}


@end
