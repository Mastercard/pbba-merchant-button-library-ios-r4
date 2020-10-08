//
//  PBBABankLogosService.h
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
@class PBBABankLogo;

typedef void (^successBlock)(NSArray <PBBABankLogo*> *logos);
typedef void (^errorBlock)(NSError *error);

@protocol PBBABankLogosService <NSObject>
@property(nonatomic,strong) NSArray <PBBABankLogo*> *logos;

- (NSInteger) nrOfLogos;
- (NSArray*) smallLogos;
@end

@interface PBBABankLogosService : NSObject <PBBABankLogosService>
- (id) initLogosServiceWithSuccessBlock: (successBlock) successBlock
                             errorBlock: (errorBlock) errorBlock;
@end

@protocol PBBABankLogosPresenterDelegate
- (void)setLogosService: (PBBABankLogosService*) logosService;
@end
