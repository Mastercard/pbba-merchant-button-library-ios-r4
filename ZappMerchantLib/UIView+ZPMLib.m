//
//  UIView+ZPMLib.m
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

#import "UIView+ZPMLib.h"
#import "NSBundle+ZPMLib.h"

static NSUInteger const kDefaultAlignmentContraintPriority = 999;

@implementation UIView (ZPMLib)

+ (instancetype)pbba_loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    
    if (nibPath) {
        NSArray *elements = [bundle loadNibNamed:nibName owner:nil options:nil];
        for (UIView *anObject in elements) {
            if ([anObject isKindOfClass:[self class]]) {
                return anObject;
            }
        }
    }
    
    return nil;
}

+ (instancetype)pbba_autolayoutReadyView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (void)pbba_height:(CGFloat)height
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:height]];
}

- (void)pbba_width:(CGFloat)width
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:width]];
}

- (void)pbba_centerInSuperview
{
    [self pbba_centerXInSuperview];
    [self pbba_centerYInSuperview];
}

- (void)pbba_centerXInSuperview
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    [self.superview addConstraint:constraint];
}

- (void)pbba_centerYInSuperview
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:0];
    [self.superview addConstraint:constraint];
}

- (void)pbba_removeAllConstraints
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self || constraint.secondItem == self) {
            [self.superview removeConstraint:constraint];
        }
    }
    
    [self removeConstraints:self.constraints];
}

- (void)pbba_pinToSuperviewEdges
{
    [self pbba_pinToSuperviewEdgesWithMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)pbba_pinToSuperviewEdgesWithMargins:(UIEdgeInsets)margins
{
    [self pbba_pinToSuperviewEdgesWithMargins:margins relation:NSLayoutRelationEqual];
}

- (void)pbba_pinToSuperviewEdgesWithMargins:(UIEdgeInsets)margins relation:(NSLayoutRelation)relation
{
    [self pbba_bottomAlignToView:self.superview constant:margins.bottom relation:relation];
    [self pbba_topAlignToView:self.superview constant:margins.top relation:relation];
    [self pbba_leftAlignToView:self.superview constant:margins.left relation:relation];
    [self pbba_rightAlignToView:self.superview constant:margins.right relation:relation];
}

- (void)pbba_unpinFromSuperview:(NSLayoutAttribute)attribute
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == attribute) {
            [self.superview removeConstraint:constraint];
        }
    }
}

- (void)pbba_leftAlignToView:(UIView *)targetView constant:(CGFloat)constant
{
    [self pbba_leftAlignToView:targetView constant:constant relation:NSLayoutRelationEqual];
}

- (void)pbba_leftAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSLayoutAttribute targetViewAttribute = (targetView == self.superview) ? NSLayoutAttributeLeading : NSLayoutAttributeTrailing;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:relation
                                                                     toItem:targetView
                                                                  attribute:targetViewAttribute
                                                                 multiplier:1
                                                                   constant:constant];
    
    constraint.priority = kDefaultAlignmentContraintPriority;
    [self.superview addConstraint:constraint];
}

- (void)pbba_rightAlignToView:(UIView *)targetView constant:(CGFloat)constant
{
    [self pbba_rightAlignToView:targetView constant:constant relation:NSLayoutRelationEqual];
}

- (void)pbba_rightAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSLayoutAttribute targetViewAttribute = (targetView == self.superview) ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:relation
                                                                     toItem:targetView
                                                                  attribute:targetViewAttribute
                                                                 multiplier:1
                                                                   constant:constant];
    constraint.priority = kDefaultAlignmentContraintPriority;
    [self.superview addConstraint:constraint];
}

- (void)pbba_topAlignToView:(UIView *)targetView constant:(CGFloat)constant
{
    [self pbba_topAlignToView:targetView constant:constant relation:NSLayoutRelationEqual];
}

- (void)pbba_topAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSLayoutAttribute targetViewAttribute = (targetView == self.superview) ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:relation
                                                                     toItem:targetView
                                                                  attribute:targetViewAttribute
                                                                 multiplier:1
                                                                   constant:constant];
    constraint.priority = kDefaultAlignmentContraintPriority;
    [self.superview addConstraint:constraint];
}

- (void)pbba_bottomAlignToView:(UIView *)targetView constant:(CGFloat)constant
{
    [self pbba_bottomAlignToView:targetView constant:constant relation:NSLayoutRelationEqual];
}

- (void)pbba_bottomAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSLayoutAttribute targetViewAttribute = (targetView == self.superview) ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:relation
                                                                     toItem:targetView
                                                                  attribute:targetViewAttribute
                                                                 multiplier:1
                                                                   constant:constant];
    constraint.priority = kDefaultAlignmentContraintPriority;
    [self.superview addConstraint:constraint];
}

- (void)pbba_equalWidthToView:(UIView *)targetView
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:targetView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    [self.superview addConstraint:constraint];
}

- (void)pbba_equalHeightToView:(UIView *)targetView
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:targetView
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1
                                                                   constant:0];
    [self.superview addConstraint:constraint];
}

@end
