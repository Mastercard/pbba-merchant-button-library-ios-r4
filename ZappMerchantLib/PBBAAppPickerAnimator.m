//
//  PBBAAppPickerAnimator.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/7/17.
//  Copyright 2017 Vocalink Limited
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

#import "PBBAAppPickerAnimator.h"

static NSString * const kPBBAAppPickerBottomConstraintIdentifier = @"com.pbba.appPicker.bottom";

@implementation PBBAAppPickerAnimator

- (instancetype)initWithAnimationType:(PBBAAppPickerAnimationType)animationType
{
    if (self = [super init]) {
        self.animationType = animationType;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animationType == PBBAAppPickerAnimationTypePresentation) {
        [self animatePresentation:transitionContext];
    } else if (self.animationType == PBBAAppPickerAnimationTypeDismissal) {
        [self animateDismissal:transitionContext];
    }
}

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Set initial configuration
    [containerView addSubview:toView];
    
    id containerItem;
    // This will be migrated to @available(iOS 11.0, *) when iOS SDK 10 (Xcode 8.3) is deprecated
    BOOL isIOS11orHigher = [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0;
    if (isIOS11orHigher) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        containerItem = containerView.safeAreaLayoutGuide;
#pragma clang diagnostic pop
    } else {
        containerItem = containerView;
    }
    
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem:toView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:containerItem
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:toView.frame.size.height];
    
    bottomConstraint.identifier = kPBBAAppPickerBottomConstraintIdentifier;
    [containerView addConstraint:bottomConstraint];
    
    NSArray *hConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toView]|"
                                            options:0
                                            metrics:nil
                                              views:NSDictionaryOfVariableBindings(toView)];
    
    [containerView addConstraints:hConstraints];
    [containerView layoutIfNeeded];
    
    bottomConstraint.constant = 0;
    containerView.alpha = 0.5;
    containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         containerView.alpha = 1;
                         [containerView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    
    NSLayoutConstraint *bottomConstraint;
    for (NSLayoutConstraint *constraint in containerView.constraints) {
        if ([constraint.identifier isEqualToString:kPBBAAppPickerBottomConstraintIdentifier]) {
            bottomConstraint = constraint;
            break;
        }
    }
    
    bottomConstraint.constant = fromView.frame.size.height;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         containerView.backgroundColor = [UIColor clearColor];
                         [containerView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [fromView removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
