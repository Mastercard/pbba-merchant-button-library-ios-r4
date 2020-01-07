//
//  PBBAExpiryTimer.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 13/10/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
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
