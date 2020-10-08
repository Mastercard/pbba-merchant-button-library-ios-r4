//
//  PBBANetworkService.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 25/09/2018.
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
