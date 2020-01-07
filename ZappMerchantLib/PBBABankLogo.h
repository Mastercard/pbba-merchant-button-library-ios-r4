//
//  PBBABankLogo.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 21/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBBABankLogo : NSObject

@property (nullable, nonatomic, copy) NSString* bankName;
@property (nullable, nonatomic, copy) NSURL* largeImageURL;
@property (nullable, nonatomic, copy) NSURL* smallImageURL;


/**
 *  Designated initialiser for PBBABankLogo model
 *  @param dict                   The provided dictionary with key/value pairs
 *
 */
- (nullable instancetype)initWithDictionary: (NSDictionary* ) dict;
 
/**
 *  Designated initialiser for PBBABankLogo model
 *
 *  @param bankName                   The provided bank name
 *  @param largeImageURL              The provided large image url, used in More About popup
 *  @param smallImageURL              The provided small image url, used in PBBA Button
 *
 */
- (nullable instancetype)initWithBankName:(NSString*)bankName
                            largeImageURL:(NSURL*)largeImageURL
                            smallImageUrl:(NSURL*)smallImageURL;
@end
