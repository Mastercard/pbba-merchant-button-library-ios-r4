//
//  PBBACountDownTimer.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 13/10/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  To ensure that you class can be updated about the transaction, ensure you conform to this protocol.
 */
@protocol PBBAExpiryTimerDelegate <NSObject>

@required

/**
 *  Used to return the timerValue back to interface when the timer is being updated.
 *
 *  @param timerValue The timer value to update. (in seconds)
 */
- (void)timerDidUpdateWithValue:(NSUInteger) timerValue;
- (void)timerExpired;
@end

@interface PBBAExpiryTimer : NSObject
@property (nonatomic, weak) id<PBBAExpiryTimerDelegate> subscriber;
- (instancetype) initWithExpiryInterval: (NSUInteger) expiryInterval;

@end
