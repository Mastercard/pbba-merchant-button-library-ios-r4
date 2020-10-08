//
//  PBBAPopupAnimator.h
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

#import <UIKit/UIKit.h>

/**
 *  Popup animation type
 */
typedef NS_ENUM(NSInteger, PBBAPopupAnimationType) {
    /**
     *  The animation used during presentation
     */
    PBBAPopupAnimationTypePresention,
    /**
     *  The animation used during dismissal
     */
    PBBAPopupAnimationTypeDismissal,
    /**
     *  The animation used during content transition (child view controllers transition)
     */
    PBBAPopupAnimationTypeContentTransition,
    /**
     *  The animation used for scaling down the popup if there is no enough space for it (landscape on small screens)
     */
    PBBAPopupAnimationTypeScaleAspectFit
};

/**
 *  Popup animator
 */
@interface PBBAPopupAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  Popup animation type
 */
@property (nonatomic, assign) PBBAPopupAnimationType animationType;

/**
 *  Get an animator instance for given animation type.
 *
 *  @param animationType The animation type.
 *
 *  @return An instance of PBBAPopupAnimator class.
 */
- (instancetype)initWithAnimationType:(PBBAPopupAnimationType)animationType;

@end
