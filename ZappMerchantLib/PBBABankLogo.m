//
//  PBBALogo.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 21/09/2018.
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

#import "PBBABankLogo.h"

#define kPBBABankLargeLogoURLKey @"longLogo"
#define kPBBABankSmallLogoURLKey @"shortLogo"
#define kPBBABankNameKey @"name"

@implementation PBBABankLogo


- (nullable instancetype)initWithDictionary: (NSDictionary* ) dict {
    if (self = [self initWithBankName:dict[kPBBABankNameKey]
                        largeImageURL:[NSURL URLWithString:dict[kPBBABankLargeLogoURLKey]]
                        smallImageUrl:[NSURL URLWithString:dict[kPBBABankSmallLogoURLKey]]])
    {
        if ([self validate]) return self;
    }
    return nil;
}

- (nullable instancetype)initWithBankName:(NSString*)bankName
                            largeImageURL:(NSURL*)largeImageURL
                            smallImageUrl:(NSURL*)smallImageURL
{
    if (self = [super init]) {
        self.bankName = bankName;
        self.largeImageURL = largeImageURL;
        self.smallImageURL = smallImageURL;
        
        
        if ([self validate]) return self;
    }
    return self;
}

- (BOOL) validate {
    return _bankName && (_largeImageURL || _smallImageURL);
}

@end
