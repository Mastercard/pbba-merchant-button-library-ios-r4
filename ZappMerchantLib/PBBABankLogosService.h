//
//  PBBABankLogosService.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 21/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
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
