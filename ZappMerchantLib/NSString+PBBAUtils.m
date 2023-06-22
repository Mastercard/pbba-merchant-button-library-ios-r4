//
//  NSString+PBBAUtils.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/24/17.
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

#import "NSString+PBBAUtils.h"

@implementation NSString (PBBAUtils)

+ (instancetype)pbba_URLSafeBase64Encode:(NSData *)data
{
    NSString *encodedString = [data base64EncodedStringWithOptions:0];
    
    return [[encodedString
             stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
            stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

- (NSData *)pbba_URLSafeBase64Decode
{
    // Make sure that the input base64 encoded string has the proper padding.
    // See: https://tools.ietf.org/html/rfc7515#appendix-C for details.
    NSString *correctBase64String = self;
    
    correctBase64String = [correctBase64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    correctBase64String = [correctBase64String stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    if (self.length % 4) {
        NSUInteger paddedLength = self.length + (4 - (self.length % 4));
        correctBase64String = [correctBase64String stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
    }
    
    return [[NSData alloc] initWithBase64EncodedString:correctBase64String options:0];
}

- (instancetype)pbba_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
