//
//  PBBAAppPickerItemCell.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/11/17.
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

#import "PBBAAppPickerItemCell.h"

NSString * const PBBAAppPickerItemCellIdentifier = @"PBBAAppPickerItemCell";

@interface PBBAAppPickerItemCell ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation PBBAAppPickerItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.appIconImageView.clipsToBounds = YES;
    self.appIconImageView.layer.cornerRadius = 7;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    self.appNameLabel.alpha = (highlighted) ? 0.5 : 1;
}

- (BOOL)isSeparatorHidden
{
    return self.separatorView.isHidden;
}

- (void)setHideSeparator:(BOOL)hide
{
    self.separatorView.hidden = hide;
}

@end
