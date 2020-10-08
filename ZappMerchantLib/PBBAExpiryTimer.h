//
//  PBBACountDownTimer.h
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
