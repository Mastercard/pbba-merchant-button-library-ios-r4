//
//  PBBACustomButton.m
//  ZappMerchantLib
//
//  Created by Ujjwal on 05/11/18.
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

#import "PBBACustomButton.h"
#import "NSBundle+ZPMLib.h"
#import "UIView+ZPMLib.h"
#import "UIFont+ZPMLib.h"
#import "UIColor+ZPMLib.h"
#import "UIImage+ZPMLib.h"

#import "PBBACustomButtonBankLogosContainer.h"

#define PBBACFILogosLayoutNibName @"PBBACustomButtonCFILogos"

@interface PBBACustomButton()
@property (nonatomic, strong) UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *logosContainerView;
@property (nonatomic, strong) PBBABankLogosService* logosService;
@property (nonatomic, strong) UIView *container;

@end

@implementation PBBACustomButton
@synthesize
customUXType = _customUXType;



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setCustomUXConfigurationsForType:(PBBACustomUXType)customUXType;
{
    _customUXType = customUXType;
    [_container removeFromSuperview];
    [self setup];
}

- (void)setup
{
    NSString* nibName = NSStringFromClass(self.class);
    NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    
    if (nibPath)
    {
        NSArray* elements = [bundle loadNibNamed:nibName owner:nil options:nil];
        for (UIView* view in elements)
        {
            if (view.tag == _customUXType) {
                _container = view;
            }
        }
    }
   
    [self addSubview:self.container];
    [_container setFrame:self.frame];
    [_container pbba_pinToSuperviewEdges];
    [self setupStyle];
}

- (void)setupStyle
{
    [self.container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         self.logosService =  [[PBBABankLogosService alloc] initLogosServiceWithSuccessBlock:nil errorBlock:nil];
         
         if ([obj isKindOfClass:[UIImageView class]])
         {
             UIImageView *brandImageView = obj;
             brandImageView.image  = [UIImage pbba_imageNamed:@"full-image-title"];
         }
             if ([obj isKindOfClass:[UIButton class]])
         {
             UIButton* moreAboutButton = obj;
             [moreAboutButton.titleLabel setFont:[UIFont pbba_boldFontWithSize:12.0f]];
             [moreAboutButton.titleLabel setTextColor:[UIColor pbba_buttonBackgroundColor]];
             [moreAboutButton setTitle:PBBALocalizedString(@"com.zapp.pbba.button.moreAbout") forState:UIControlStateNormal];
             [moreAboutButton addTarget:self action:@selector(openMoreAbout) forControlEvents:UIControlEventTouchUpInside];
         }
         if ([obj isKindOfClass:[PBBACustomButtonBankLogosContainer class]])
         {
             PBBACustomButtonBankLogosContainer* bankLogosContainer = obj;
             NSInteger x = 0;
             NSInteger y = 0;

             for (int i = 0; i < [self.logosService.smallLogos count]; i++)
             {
                 if (x > self.frame.size.width)
                 {
                     x = 0;
                     y = 35;
                 }
                 x += 35;
             }

             NSLayoutConstraint *heightConstant =  bankLogosContainer.constraints.lastObject;
             if (![self.logosService.smallLogos count]) {
                 heightConstant.constant = 0;
             } else {
                 heightConstant.constant = y+30;
             }
             [bankLogosContainer updateConstraints];
             [bankLogosContainer setLogosService:self.logosService];
         }
     }];
}

- (void)openMoreAbout {
    [PBBAAppUtils showPBBAMoreAboutPopup:[UIApplication sharedApplication].keyWindow.rootViewController withLogosService:self.logosService];
}

@end
