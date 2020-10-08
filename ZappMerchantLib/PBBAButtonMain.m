//
//  PBBAButtonMain.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 19/09/2018.
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

#import "PBBAButtonMain.h"
#import "PBBABankLogosService.h"
#import "PBBASquiggleView.h"
#import "UIColor+ZPMLib.h"
#import "UIView+ZPMLib.h"
#import "NSBundle+ZPMLib.h"
#import "PBBABankLogo.h"
#import "UIFont+ZPMLib.h"
#import "PBBAButton.h"

static NSTimeInterval const kPBBAButtonActivityTimerTimeInterval = 10;

@interface PBBALogosArea : UIView
- (void) setupImagesForLogosService: (PBBABankLogosService *) logosService;
@end

@implementation PBBALogosArea
- (void) setupImagesForLogosService: (PBBABankLogosService *) logosService {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                PBBABankLogo* logo = logosService.smallLogos[idx];
                
                NSData * data = [[NSData alloc] initWithContentsOfURL: logo.smallImageURL];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView* imv = obj;
                    imv.image = [UIImage imageWithData: data];
                    imv.contentMode = UIViewContentModeScaleAspectFit;
                    imv.backgroundColor = [UIColor whiteColor];
                    imv.layer.cornerRadius = 4.0f;
                    imv.layer.borderWidth = 0;
                    imv.layer.masksToBounds = YES;
                    imv.accessibilityLabel= logo.bankName;
                });
            });
        }
    }];
}
@end

@interface PBBAButtonTitleView : UIView
@end

@implementation PBBAButtonTitleView
@end


@interface PBBAButtonMain ()
@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, weak) NSTimer *activityTimer;
@property (nonatomic, strong) PBBABankLogosService* logosService;
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) PBBALogosArea *logosArea;
@property (nonatomic, strong) PBBAButtonTitleView *titleView;
@property (nonatomic, strong) PBBASquiggleView *squiggleView;
@end

@implementation PBBAButtonMain

@dynamic backgroundColor;

@synthesize cornerRadius = _cornerRadius,
borderColor = _borderColor,
borderWidth = _borderWidth,
foregroundColor = _foregroundColor,
secondaryForegroundColor = _secondaryForegroundColor,
mainContainerView = _mainContainerView,
squiggleView = _squiggleView;

#pragma mark - Initialization

- (instancetype)initWithLogosService:(PBBABankLogosService *)logosService
                            delegate: (id) delegate {
    
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        _logosService = logosService;
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.clipsToBounds = YES;
//    self.isAccessibilityElement = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.accessibilityIdentifier = @"com.zapp.button";
//    self.accessibilityLabel = @"Pay by bank app";
    
    [self addSubview:self.mainContainerView];
    [self setupImages];
    
    [self.mainContainerView pbba_pinToSuperviewEdges];
    [self pbba_width:310];
    [self pbba_height:48];
    [self.mainContainerView pbba_equalHeightToView:self];
    [self.mainContainerView pbba_equalWidthToView:self];
   
    [self setupStyle];
    [self startAnimating];
    [self stopAnimating];
    [self setupSelector];
    
}

- (void) setupImages {
    [self.mainContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull viewWithImages, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([viewWithImages isKindOfClass:[PBBALogosArea class]]) {
            PBBALogosArea* logosArea = viewWithImages;
            [logosArea setupImagesForLogosService:self.logosService];
            *stop = YES;
        }
    } ];
}

- (void)setupStyle
{
    self.backgroundColor = [UIColor pbba_buttonBackgroundColor];
    self.foregroundColor = [UIColor pbba_buttonForegroundColor];
    self.highlightedBackgroundColor = [UIColor pbba_buttonHighlightedColor];
    self.cornerRadius = 4.0f;
    self.borderWidth = 0;
    self.originalBackgroundColor = self.backgroundColor;
}

#pragma mark - Action

- (void) setupSelector {
    
    // Disabe user interaction for all subviews. If at least one will be enabled - UIControl won't react.
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
    }];
    [self addTarget:self action:@selector(tapControl) forControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    self.userInteractionEnabled = YES;
}

- (BOOL)tapControl
{
    if (!self.enabled) return NO;
    
    if ([self.delegate respondsToSelector:@selector(notifyPbbaButtonDidPress)] &&
        [self.delegate notifyPbbaButtonDidPress]) {
        
        self.enabled = NO;
        [self startActivityTimer];
        [self startAnimating];
        return YES;
    }
    
    return NO;
}

#pragma mark - Custom View Initialization

- (PBBASquiggleView *)squiggleView {
    if (!_squiggleView) {
        [self.titleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // Setup Squiggle View
            if ([obj isKindOfClass:[UIView class]]) {
                
                // Initilize
                _squiggleView = [[PBBASquiggleView alloc] initWithFrame:CGRectZero];
                
                // Layout Squiggle in Superview
                [self.titleView addSubview:self.squiggleView];
                [self.squiggleView pbba_leftAlignToView:self.titleView constant:0];
                [self.squiggleView pbba_topAlignToView:self.titleView constant:0];
                [self.squiggleView pbba_height:self.squiggleView.frame.size.height];
                [self.squiggleView pbba_height:self.squiggleView.frame.size.width];
                
                // Configure Appearancce
                self.squiggleView.tintColor = UIColor.whiteColor;
                *stop = YES;
            }
        }];
    }
    return _squiggleView;
}

- (UIView *) mainContainerView {
    
    if (!_mainContainerView) {
        
        // Load layou from nib, by nr on images
        NSString* nibName = NSStringFromClass(self.class);
        NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
        NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
        
        NSInteger nrOfImages = self.logosService.smallLogos.count;
        
        if (nibPath) {
            NSArray* elements = [bundle loadNibNamed:nibName owner:nil options:nil];
            for (UIView* view in elements) {
                if (view.tag == nrOfImages) {
                    _mainContainerView = view;
                    [_mainContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[PBBAButtonTitleView class]]) {
                            _titleView = obj;
                            *stop = YES;
                        }
                    }];
                    [_mainContainerView setBackgroundColor:UIColor.clearColor];
                    _mainContainerView.clipsToBounds = YES;
                    return _mainContainerView;
                }
            }
        }
    }
    
    return _mainContainerView;
}

#pragma mark - Timer logic

- (void)startActivityTimer
{
    self.activityTimer = [NSTimer scheduledTimerWithTimeInterval:kPBBAButtonActivityTimerTimeInterval
                                                          target:self
                                                        selector:@selector(activityTimerDidFire:)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)activityTimerDidFire:(NSTimer *)activityTimer
{
    self.enabled = YES;
}


#pragma mark - UIControlState override

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.highlighted == highlighted) return;
    
    [super setHighlighted:highlighted];
    
    if (self.enabled) {
        self.backgroundColor = (highlighted)
        ? self.highlightedBackgroundColor
        : self.originalBackgroundColor;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.enabled == enabled) return;
    
    [super setEnabled:enabled];
    
    if (enabled) {
        [self stopAnimating];
        [self.activityTimer invalidate];
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.originalBackgroundColor;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = self.highlightedBackgroundColor;
        }];
    }
}

#pragma mark - UIAppearance override

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
    self.tintColor = foregroundColor;
    self.mainContainerView.tintColor = foregroundColor;
}

#pragma mark - PBBAAnimatable impementation

- (void)startAnimating
{
    [self.squiggleView startAnimating];
}

- (void)stopAnimating
{
    [self.squiggleView stopAnimating];
}

- (BOOL)isAnimating
{
    return [self.squiggleView isAnimating];
}

@end
