//
//  PBBABankLogosService.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 21/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBABankLogosService.h"
#import "PBBABankLogo.h"
#import "PBBANetworkService.h"
#import "PBBALibraryUtils.h"

static int maxLogosAllowed = 8;

@interface NSMutableArray (Shuffle)
- (void) shuffle;
@end

@implementation NSMutableArray (Shuffle)
- (void)shuffle {
    NSUInteger count = [self count];
    if (count <= 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}
@end

@implementation PBBABankLogosService
@synthesize logos = _logos;

- (id) initLogosServiceWithSuccessBlock: (successBlock) successBlock
                             errorBlock: (errorBlock) errorBlock
{
    self = [super init];
    if (self) {
        NSMutableArray* (^success)(NSMutableArray <PBBABankLogo*> * array) = ^NSMutableArray* (NSMutableArray * unfilteredArray) {
            NSMutableArray <PBBABankLogo*> *filteredArray = [self filterImages:unfilteredArray];
            [filteredArray shuffle];
            return filteredArray;
        };
        
        void (^failure)(NSError* error) = ^(NSError* error) {
            NSLog(@"PBBABankLogosService: Failed to load logos, error: %@",error.description);
            if (errorBlock) {
                errorBlock(error);
            }
        };
        
            PBBANetworkService* networkService = [PBBANetworkService new];
            [networkService getBankLogosWithBlock:^(NSArray *elements, NSError *error) {
                if (elements) {
                    self.logos = success(elements);
                    if (successBlock) {
                        successBlock(self.logos);
                    }
                } else {
                    failure(error);
                }
            }];
    }
    return self;
}

- (NSMutableArray <PBBABankLogo*> *) filterImages: (NSArray*) images {
    NSMutableArray <PBBABankLogo*> *finalImagesList = [[NSMutableArray alloc] init];
    [images enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PBBABankLogo* logo = [[PBBABankLogo alloc] initWithDictionary:obj];
        if (logo)  [finalImagesList addObject:logo];
        if ([finalImagesList count]==maxLogosAllowed) *stop = YES;
    }];
    return finalImagesList;
}

- (NSArray*) smallLogos {
    NSMutableArray* smallLogosArray = [[NSMutableArray alloc] init];
    [self.logos enumerateObjectsUsingBlock:^(PBBABankLogo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.smallImageURL) {
            [smallLogosArray addObject:obj];
        }
    }];
    return smallLogosArray;
}

- (NSInteger) nrOfLogos {
    return _logos.count;
}

@end
