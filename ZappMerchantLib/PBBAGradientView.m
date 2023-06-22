//
//  PBBAGradientView.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/13/17.
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

#import "PBBAGradientView.h"

@interface PBBAGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PBBAGradientView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
}

- (void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    
    self.backgroundColor = [UIColor clearColor];
    [self.gradientLayer removeFromSuperlayer];
    [self addGradientLayer:colors];
}

- (void)addGradientLayer:(NSArray<UIColor *> *)colors
{
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    
    self.gradientLayer.colors = cgColors;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

@end
