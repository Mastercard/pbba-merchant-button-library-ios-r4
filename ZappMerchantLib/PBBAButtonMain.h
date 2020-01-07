//
//  PBBAButtonMain.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 19/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBBAAnimatable.h"
#import "PBBAUIElementAppearance.h"

@class PBBAButtonMain,PBBABankLogosService;

/**
 *  PBBA payment button delegate.
 */
@protocol PBBAButtonMainDelegate <NSObject>

/**
 *  Tell the delegate that payment button was pressed.
 *
 *  @param pbbaButton The instance of payment button which was pressed.
 *
 *  @return YES if you want to disable the payment button and start payment activity animation.
 */
- (BOOL)notifyPbbaButtonDidPress;

@end


@interface PBBAButtonMain : UIControl <PBBAUIElementAppearance, PBBAAnimatable>
/**
 *  The payment button delegate.
 */
@property (nullable, nonatomic, weak) IBOutlet id<PBBAButtonMainDelegate> delegate;
- (instancetype)initWithLogosService:(PBBABankLogosService *)logosService
                            delegate: (id) delegate ;
@end
