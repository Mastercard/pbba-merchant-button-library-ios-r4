//
//  PBBANetworkService.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 25/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBANetworkService.h"

static NSString* PBBALogosSorageLink = @"https://paybybankappcdn.mastercard.co.uk/static/ml/pbba-3550ce7763041531b9214e9e23986b37/merchant-lib/banks.json";

@implementation PBBANetworkService
@synthesize url;

+ (PBBANetworkService *)serviceWithURL:(NSURL *)url
{
    PBBANetworkService *service = [PBBANetworkService new];
    service.url = url;
    return service;
}

- (void)getBankLogosWithBlock:(serviceCompletionBlock)block
{
     NSURL *url = [NSURL URLWithString:PBBALogosSorageLink];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CDNUrl"]) {
        url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CDNUrl"]];
    }
    
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data) {
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        block(array ? array : nil, error ? error : nil);
    } else block(nil,[NSError errorWithDomain:@"No URL contents" code:404 userInfo:@{NSLocalizedDescriptionKey:@"URL does not contain any data"}]);
}

        
@end
