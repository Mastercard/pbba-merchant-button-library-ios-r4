//
//  PBBAPopupScaleAspectFitAnimationContext.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/4/16.
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

#import "PBBAPopupScaleAspectFitAnimationContext.h"
#import "PBBAPopupContainerController.h"

static UIEdgeInsets const kScreenMargins = {20, 0, 20, 0};

@interface PBBAPopupScaleAspectFitAnimationContext ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) PBBAPopupContainerController *popupContainerController;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, strong) NSDictionary<NSString *, UIViewController *> *viewControllers;

@end

@implementation PBBAPopupScaleAspectFitAnimationContext

- (instancetype)initWithPopupContainerController:(PBBAPopupContainerController *)controller
{
    if (self = [super init]) {
        
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = controller.view.superview;
        self.viewControllers = @{
            UITransitionContextFromViewControllerKey : controller,
            UITransitionContextToViewControllerKey : controller,
        };
        
        self.popupContainerController = controller;
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
    return self.popupContainerController.view.bounds;
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    // Compute available frame for view controller
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect viewRect = [self initialFrameForViewController:viewController];
    
    CGFloat avalableVerticalSpace = CGRectGetHeight(screenRect) - kScreenMargins.top - kScreenMargins.bottom;
    CGFloat preferredVerticalHeight = CGRectGetHeight(viewRect);
    CGFloat finalHeight = (avalableVerticalSpace < preferredVerticalHeight) ? avalableVerticalSpace : preferredVerticalHeight;
    
    viewRect.size.height = finalHeight;
    
    return viewRect;
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
