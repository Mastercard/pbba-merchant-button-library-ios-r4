//
//  PBBAAppearance.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/16/16.
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

#import "PBBAAppearance.h"
#import "UIColor+ZPMLib.h"

@implementation PBBAAppearance

@synthesize borderColor = _borderColor,
            borderWidth = _borderWidth,
            cornerRadius = _cornerRadius,
            backgroundColor = _backgroundColor,
            foregroundColor = _foregroundColor,
            secondaryForegroundColor = _secondaryForegroundColor;

+ (instancetype)appearance
{
    return nil;
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return nil;
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
{
    return nil;
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.foregroundColor = [UIColor blackColor];
        self.borderColor = [UIColor pbba_pbbaBrandColor];
        self.secondaryForegroundColor = [UIColor pbba_pbbaBrandColor];
        self.cornerRadius = 4.0f;
        self.borderWidth = 2.0f;
    }
    
    return self;
}

@end
