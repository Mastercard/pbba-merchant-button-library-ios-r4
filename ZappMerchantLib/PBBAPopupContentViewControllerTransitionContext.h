//
//  PBBAPopupContentViewControllerTransitionContext.h
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
 *  Animation context for the animation used during content transition.
 */
@interface PBBAPopupContentViewControllerTransitionContext : NSObject <UIViewControllerContextTransitioning>

/**
 *  The animation completion handler.
 */
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);

/**
 *  Get an instance of animation context for given from/to controllers.
 *
 *  @param fromViewController The source controller from which the transition starts.
 *  @param toViewController   The destination controller where transition ends.
 *
 *  @return An instance of PBBAPopupContentViewControllerTransitionContext class.
 */
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController;

@end
