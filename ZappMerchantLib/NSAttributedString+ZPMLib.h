//
//  NSAttributedString+ZPMLib.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 8/12/14.
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

@interface NSAttributedString (ZPMLib)

+ (NSAttributedString *)pbba_highlightFragments:(NSArray *)fragments
                                         inText:(NSString *)text
                                       withFont:(UIFont *)standardFont
                                 hightlightFont:(UIFont *)highlightFont
                                      alignment:(NSTextAlignment)alignment;

+ (NSAttributedString *)pbba_highlightByFontFragment:(NSString*)fontFragment
                                     byColorFragment:(NSString*)colorFragment
                                              inText:(NSString *)text
                                            withFont:(UIFont *)standardFont
                                      hightlightFont:(UIFont *)highlightFont
                                      highlightColor:(UIColor*)highlightColor
                                           alignment:(NSTextAlignment)textAlignment;

@end
