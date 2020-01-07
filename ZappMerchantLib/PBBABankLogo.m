//
//  PBBALogo.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 21/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
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
