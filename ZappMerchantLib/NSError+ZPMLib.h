//
//  NSError+ZPMLib.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 01/11/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ZPMLib)

+ (NSError*) errorWithCode: (NSString*) code
                     Title: (NSString*) title
                andMessage: (NSString*) message;

@end
