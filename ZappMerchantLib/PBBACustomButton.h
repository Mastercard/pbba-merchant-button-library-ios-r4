//
//  PBBACustomButton.h
//  ZappMerchantLib
//
//  Created by Ujjwal on 05/11/18.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBBAAppUtils.h"

@interface PBBACustomButton : UIView
@property (nonatomic, assign) NSInteger customUXType;
-(void)setCustomUXConfigurationsForType:(PBBACustomUXType)customUXType;
@end
