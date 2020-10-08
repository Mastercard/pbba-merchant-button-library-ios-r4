//
//  PBBAAnimatable.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 5/31/16.
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

#ifndef PBBAAnimatable_h
#define PBBAAnimatable_h

/**
 *  Protocol for animatable views.
 */
@protocol PBBAAnimatable <NSObject>

/**
 *  Start animation.
 */
- (void)startAnimating;

/**
 *  Stop animation.
 */
- (void)stopAnimating;

/**
 *  Check if animation is in progress.
 *
 *  @return YES if animation is in progress.
 */
- (BOOL)isAnimating;

@end

#endif /* PBBAAnimatable_h */
