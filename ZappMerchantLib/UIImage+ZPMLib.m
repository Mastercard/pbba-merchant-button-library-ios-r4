//
//  UIImage+ZPMLib.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 02/07/2014.
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

#import "UIImage+ZPMLib.h"
#import "NSBundle+ZPMLib.h"

@implementation UIImage (ZPMLib)

+ (UIImage *)pbba_errorImage
{
    return [self pbba_templateImageNamed:@"icon_error"];
}

+ (UIImage *)pbba_pbbaTitleImage
{
    return [self pbba_templateImageNamed:@"full-image-title"];
}

+ (UIImage *)pbba_zappCodeImage
{
    return [self pbba_templateImageNamed:@"image-code"];
}

+ (UIImage *)pbba_imageNamed:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
    NSString *imgName = [imageName stringByDeletingPathExtension];
    
    return [UIImage imageNamed:imgName inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)pbba_templateImageNamed:(NSString *)imageName
{
    return [[self pbba_imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)pbba_templateImage
{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)pbba_tintedWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end
