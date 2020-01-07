//
//  UIView+ZPMLib.h
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

#import <UIKit/UIKit.h>

@interface UIView (ZPMLib)

+ (instancetype)pbba_autolayoutReadyView;
+ (instancetype)pbba_loadFromNib;

- (void)pbba_removeAllConstraints;
- (void)pbba_height:(CGFloat)height;
- (void)pbba_width:(CGFloat)width;
- (void)pbba_centerInSuperview;
- (void)pbba_centerXInSuperview;
- (void)pbba_centerYInSuperview;
- (void)pbba_pinToSuperviewEdges;
- (void)pbba_pinToSuperviewEdgesWithMargins:(UIEdgeInsets)margins;
- (void)pbba_pinToSuperviewEdgesWithMargins:(UIEdgeInsets)margins relation:(NSLayoutRelation)relation;
- (void)pbba_unpinFromSuperview:(NSLayoutAttribute)attribute;
- (void)pbba_leftAlignToView:(UIView *)targetView constant:(CGFloat)constant;
- (void)pbba_rightAlignToView:(UIView *)targetView constant:(CGFloat)constant;
- (void)pbba_topAlignToView:(UIView *)targetView constant:(CGFloat)constant;
- (void)pbba_bottomAlignToView:(UIView *)targetView constant:(CGFloat)constant;
- (void)pbba_leftAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation;
- (void)pbba_rightAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation;
- (void)pbba_topAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation;
- (void)pbba_bottomAlignToView:(UIView *)targetView constant:(CGFloat)constant relation:(NSLayoutRelation)relation;
- (void)pbba_equalWidthToView:(UIView *)targetView;
- (void)pbba_equalHeightToView:(UIView *)targetView;

@end
