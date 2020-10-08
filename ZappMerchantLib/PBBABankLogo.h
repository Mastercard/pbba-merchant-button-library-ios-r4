//
//  PBBABankLogo.h
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
