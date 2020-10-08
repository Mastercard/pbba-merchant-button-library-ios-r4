//
//  PBBATypes.h
//  ZappMerchantLib
//
//  Created by Alex Maimescu on 06/10/2017.
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

#ifndef PBBATypes_h
#define PBBATypes_h

/**
 *  The PBBA API request type.
 */
typedef NS_ENUM(NSInteger, PBBARequestType) {
    /**
     *  The Request to Pay type (RTP).
     */
    PBBARequestTypeRequestToPay,
    /**
     *  The Request to Link type (RTL).
     */
    PBBARequestTypeRequestToLink,
    /**
     *  The Request to Pay type (RTP + Link), with linking
     */
    PBBARequestTypeRequestToLinkAndPay
};

#endif /* PBBATypes_h */
