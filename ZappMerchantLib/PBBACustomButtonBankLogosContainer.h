//
//  PBBAMoreAboutBankLogostContainer.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 10/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBAAutoLoadableView.h"
#import "PBBABankLogosService.h"

@interface PBBACustomButtonBankLogosContainer : PBBAAutoLoadableView <PBBABankLogosPresenterDelegate>
- (void)setLogosService:(PBBABankLogosService *)logosService;
@end
