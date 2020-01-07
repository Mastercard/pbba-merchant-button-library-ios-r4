//
//  PBBASquiggleView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 7/10/15.
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

#import "PBBASquiggleView.h"
#import "UIImage+ZPMLib.h"
#import "UIColor+ZPMLib.h"
#import "PBBAUIElementAppearance.h"

@interface PBBASquiggleView ()

@property (nonatomic, strong) UIImageView *squiggleImageView;

@end

@implementation PBBASquiggleView

#pragma mark - UIView Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    if ([tintColor isEqual:[UIColor pbba_buttonForegroundColor]]) {
        [self setAnimationImagesWithCustomColor:NO];
    } else {
        [self setAnimationImagesWithCustomColor:YES];
    }
}

- (void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImage *squiggleImage = [UIImage pbba_templateImageNamed:@"squiggle-part-15"];
    NSAssert(squiggleImage, @"ZappPaymentsButton assets not loaded. Make sure that ZappMerchantLib resources are being loaded.");
    self.squiggleImageView = [[UIImageView alloc] initWithImage:squiggleImage];
    self.squiggleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.squiggleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.squiggleImageView.animationDuration = 2.3f;
    
    [self addSubview:self.squiggleImageView];
    
    NSDictionary *bindedViews = @{@"squiggleImageView": self.squiggleImageView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[squiggleImageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[squiggleImageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:bindedViews]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setAnimationImagesWithCustomColor:(BOOL)custom
{
    NSMutableArray *animationImages = [NSMutableArray array];
    
    for (int i = 0; i <= 47; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"squiggle-part-%d", i];
        UIImage *image = [UIImage pbba_templateImageNamed:imageName];
        
        [animationImages addObject:custom ? [image pbba_tintedWithColor:self.tintColor] : image];
    }
    
    self.squiggleImageView.animationImages = animationImages;
}

- (CGSize)intrinsicContentSize
{
    CGFloat maxEdge = fmax(self.squiggleImageView.image.size.width, self.squiggleImageView.image.size.height);
    return CGSizeMake(maxEdge, maxEdge);
}

#pragma mark - PBBAAnimatable

- (BOOL)isAnimating
{
    return [self.squiggleImageView isAnimating];
}

- (void)startAnimating
{
    [self.squiggleImageView startAnimating];
}

- (void)stopAnimating
{
    [self.squiggleImageView stopAnimating];
}

@end
