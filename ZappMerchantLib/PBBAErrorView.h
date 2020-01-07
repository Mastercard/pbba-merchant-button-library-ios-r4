//
//  PBBAErrorView.h
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 01/11/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBBAErrorViewProtocol <NSObject>

- (void) errorViewRetry;

@end
@interface PBBAErrorView : UIView 

@property (nonatomic, weak) id<PBBAErrorViewProtocol> subscriber;

-(instancetype) initWithError: (NSError*) error;

@end
