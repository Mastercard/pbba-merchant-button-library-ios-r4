//
//  PBBAExpiryTimer.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 13/10/2018.
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

#import "PBBAExpiryTimer.h"

@interface PBBAExpiryTimer ()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger expiryInterval;
@end


@implementation PBBAExpiryTimer
- (instancetype) initWithExpiryInterval: (NSUInteger) expiryInterval {
    self = [super init];
    if (self) {
        self.expiryInterval = expiryInterval;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerDidFire:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
    self.expiryInterval -= 1;
    if (self.expiryInterval>0) {
        if ([self.subscriber respondsToSelector:@selector(timerDidUpdateWithValue:)]) {
            [self.subscriber timerDidUpdateWithValue:self.expiryInterval];
        }
    } else {
        [self timerDidExpire];
    }
}

- (void)timerDidExpire{
    [self.timer invalidate];
    self.timer = nil;
    if ([self.subscriber respondsToSelector:@selector(timerExpired)]) {
        [self.subscriber timerExpired];
    }
}

@end
