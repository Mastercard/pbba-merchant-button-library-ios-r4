//
//  NSError+ZPMLib.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 01/11/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "NSError+ZPMLib.h"

@implementation NSError (ZPMLib)


+ (NSError*) errorWithCode: (NSString*) code
                     Title: (NSString*) title
                andMessage: (NSString*) message {
    return [[NSError alloc] initWithDomain:NSLocalizedString(title,@"")
                                      code:0
                                  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(message,@"")}];
}

@end
