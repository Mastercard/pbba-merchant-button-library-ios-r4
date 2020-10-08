//
//  PBBAPopupContentViewControllerTransitionContext.m
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

#import "PBBAPopupContentViewControllerTransitionContext.h"

@interface PBBAPopupContentViewControllerTransitionContext ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, strong) NSDictionary<NSString *, UIViewController *> *viewControllers;

@end

@implementation PBBAPopupContentViewControllerTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
{
    if (self = [super init]) {
        
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.viewControllers = @{
            UITransitionContextFromViewControllerKey : fromViewController,
            UITransitionContextToViewControllerKey : toViewController,
        };
    }
    
    return self;
}

- (BOOL)isAnimated
{
    return YES;
}

- (BOOL)isInteractive
{
    return NO;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    return viewController.view.frame;
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    return viewController.view.frame;
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    return self.viewControllers[key];
}

- (UIView *)viewForKey:(NSString *)key
{
    return self.viewControllers[key].view;
}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}

- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }
}

- (BOOL)transitionWasCancelled
{
    return NO;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

@end
