//
//  PBBACodeView.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 15/07/2015.
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

#import "PBBAAutoLoadableView.h"

@protocol PBBACodeViewProtocol <NSObject>

- (void) codeViewExpired;

@end

@interface PBBACodeView : PBBAAutoLoadableView
/**
 
 *  The expiration interval to be shown in the popup
 */
@property (nonatomic) NSUInteger expiryInterval;
@property (nonatomic, copy) NSString *brn;
@property (nonatomic, weak) id<PBBACodeViewProtocol> subscriber;

-(instancetype) initWithBRN: (NSString*) brn
          andExpiryInterval: (NSUInteger) expiryInterval;

-(void)setBrn:(NSString *)brn
andExpiryInterval: (NSUInteger) expiryInterval;

@end
