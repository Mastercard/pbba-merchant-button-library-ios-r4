//
//  PBBAAutoLoadableView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/7/16.
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

#import "PBBAAutoLoadableView.h"
#import "UIView+ZPMLib.h"

@implementation PBBAAutoLoadableView

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    UIView *view = [super awakeAfterUsingCoder:aDecoder];
    
    if ([view.subviews count] == 0) {
        UIView *newView = [[self class] pbba_loadFromNib];
        if (newView) {
            newView.translatesAutoresizingMaskIntoConstraints = NO;
            newView.frame = view.frame;
            newView.autoresizingMask = view.autoresizingMask;
            newView.hidden = view.hidden;
            for (NSLayoutConstraint *constraint in view.constraints) {
                UIView *firstItem = constraint.firstItem;
                if (constraint.firstItem == view) {
                    firstItem = newView;
                }
                UIView *secondItem = constraint.secondItem;
                if (constraint.secondItem == view) {
                    secondItem = newView;
                }
                
                NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                                 attribute:constraint.firstAttribute
                                                                                 relatedBy:constraint.relation
                                                                                    toItem:secondItem
                                                                                 attribute:constraint.secondAttribute
                                                                                multiplier:constraint.multiplier
                                                                                  constant:constraint.constant];
                
                newConstraint.priority = constraint.priority;
                
                [newView addConstraint:newConstraint];
            }
            
            return newView;
        }
    }
    
    return view;
}

@end
