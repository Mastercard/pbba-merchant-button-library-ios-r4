//
//  PBBAErrorView.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 01/11/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBAErrorView.h"
#import "NSBundle+ZPMLib.h"


@interface PBBAErrorView ()
{
    NSError* popupError;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation PBBAErrorView

- (void)drawRect:(CGRect)rect {
    
    self.titleLabel.text = popupError.domain;
    self.messageLabel.text = popupError.localizedDescription;
}
 
 -(instancetype) initWithError: (NSError*) error
{
    if (self = [super init]){
        self = [[[NSBundle pbba_merchantResourceBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        popupError = error;
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
    };
    
    return self;
}


- (IBAction) retryButtonDidPress
{
    if ([self.subscriber respondsToSelector:@selector(errorViewRetry)])
    {
        [self.subscriber errorViewRetry];
    }

}

@end
