//
//  PBBAPopupContentViewController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/7/16.
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

#import <UIKit/UIKit.h>
#import "PBBAPopupCoordinator.h"
#import "PBBABankLogosService.h"

/**
 *  The base class for all popup content view controllers (child view controllers)
 */
@interface PBBAPopupContentViewController : UIViewController

/**
 *  The popup coordinator instance.
 */
@property (nonatomic, weak) PBBAPopupCoordinator *popupCoordinator;

/**
 *  The content view.
 */
@property (nonatomic, weak) IBOutlet UIView *contentView;

- (void) updateForBRN: (NSString*) brn
    andExpiryInterval: (NSInteger) expiryInterval;

- (void) updateForError: (NSError*) error;

@end
