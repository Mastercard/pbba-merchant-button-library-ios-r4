//
//  PBBAPopupAnimator.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/3/16.
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

#import "PBBAPopupAnimator.h"
#import "UIColor+ZPMLib.h"

static NSTimeInterval const kDefaultPresentationDuration = .3;
static NSTimeInterval const kDefaultDismissalDuration = .2;
static NSTimeInterval const kDefaultContentTransitionDuration = .2;
static NSTimeInterval const kDefaultScaleAspectFitDuration = 0;

static CGFloat const kInitialScale = 0.01;
static CGFloat const kFinalScale = 1.0;

@interface PBBAPopupAnimator () 

@end

@implementation PBBAPopupAnimator

- (instancetype)initWithAnimationType:(PBBAPopupAnimationType)animationType
{
    if (self = [super init]) {
        self.animationType = animationType;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.animationType) {
        case PBBAPopupAnimationTypePresention:
            return kDefaultPresentationDuration;
        case PBBAPopupAnimationTypeDismissal:
            return kDefaultDismissalDuration;
        case PBBAPopupAnimationTypeContentTransition:
            return kDefaultContentTransitionDuration;
        case PBBAPopupAnimationTypeScaleAspectFit:
            return kDefaultScaleAspectFitDuration;
    }
    
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (self.animationType == PBBAPopupAnimationTypePresention) {
        
        // Set initial configuration
        toView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
        toView.alpha = 0.5;
        [containerView addSubview:toView];
        
        // Scale up
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             toView.transform = CGAffineTransformMakeScale(kFinalScale, kFinalScale);
                             containerView.backgroundColor = [UIColor pbba_overlayColor];
                             toView.alpha = 1;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
        
    } else if (self.animationType == PBBAPopupAnimationTypeDismissal) {
        
        // Scale down and set final configuration
        [UIView animateWithDuration:duration animations:^{
            fromView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
            containerView.backgroundColor = [UIColor clearColor];
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else if (self.animationType == PBBAPopupAnimationTypeContentTransition) {
                
        toView.alpha = 0;
        fromView.alpha = 0;
        
        [UIView animateWithDuration:duration animations:^{
            [containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                toView.alpha = 1;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }];
        
    } else if (self.animationType == PBBAPopupAnimationTypeScaleAspectFit) {
        
        CGAffineTransform scaleTransform;
        CGFloat finalHeight = CGRectGetHeight([transitionContext finalFrameForViewController:toVC]);
        CGFloat initialHeight = CGRectGetHeight([transitionContext initialFrameForViewController:toVC]);
        CGFloat scaleFactor = finalHeight / initialHeight;
        scaleTransform = (scaleFactor > 1) ? CGAffineTransformIdentity : CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        
        [UIView animateWithDuration:duration animations:^{
            toView.transform = scaleTransform;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end