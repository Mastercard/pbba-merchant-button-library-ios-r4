//
//  PBBANetworkService.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 25/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBBANetworkService;

/**
 *  ^serviceCompletionBlock
 *
 *  @param elements JSON response dictionary
 *  @param error      The request error
 */
typedef void (^serviceCompletionBlock)(NSArray *elements, NSError *error);


@protocol PBBANetworkService <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

/**
 * The URL to be connect.
 */

@property(nonatomic,strong) NSURL *url;

/**
 * Helper method to instantiate an object.
 */

+ (PBBANetworkService *)serviceWithURL:(NSURL *)url;

/**
 * GET Method to invoke the service call.
 */
- (void)getBankLogosWithBlock:(serviceCompletionBlock)block;

@end

@interface PBBANetworkService : NSObject <PBBANetworkService>

@end
