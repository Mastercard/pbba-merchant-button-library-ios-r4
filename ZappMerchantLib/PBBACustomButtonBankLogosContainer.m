//
//  PBBAMoreAboutBankLogostContainer.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 10/09/2018.
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

#import "PBBACustomButtonBankLogosContainer.h"
#import "NSBundle+ZPMLib.h"
#import "UIView+ZPMLib.h"
#import "PBBABankLogo.h"

#define kPBBABankLogosLayoutNibName @"PBBACustomButtonBankLogosLayouts"

@interface PBBACustomButtonBankLogosContainer ()


@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (weak, nonatomic) IBOutlet UIView *logosContainerView;
@property(strong, nonatomic) PBBABankLogosService *logosService;
@end

@implementation PBBACustomButtonBankLogosContainer

- (void) layoutLayout: (UIView*) logosLayout
{
    logosLayout.translatesAutoresizingMaskIntoConstraints = NO;
    [logosLayout pbba_pinToSuperviewEdges];
    [logosLayout setNeedsLayout];
    [logosLayout layoutIfNeeded];
}

- (void)loadLayoutForImages: (NSArray* ) images
{
    NSInteger x = 0;
    NSInteger y = 0;

    for (int i = 0; i < [self.logosService.smallLogos count]; i++)
    {
        if (x > self.frame.size.width)
        {
            x = 0;
            y = 35;
        }
        CGRect frame = CGRectMake(x, y, 30, 30);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            PBBABankLogo* logo = self.logosService.smallLogos[i];
            NSData * data = [[NSData alloc] initWithContentsOfURL: logo.smallImageURL];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData: data];
                imageView.layer.borderWidth = 0.5;
                imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                imageView.layer.cornerRadius = 5.0;
            });
        });
        [self addSubview:imageView];
        x += 35;
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, y+30)];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    _availabilityLabel.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.logosContainerAvailability");
    
    
    self.logosService =  [[PBBABankLogosService alloc] initLogosServiceWithSuccessBlock:^(NSArray<PBBABankLogo *> *logos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.logosService.nrOfLogos > 0){
                [self loadLayoutForImages:self.logosService.smallLogos];
            } else {
                self.hidden = YES;
//                NSLog(@"PBBABankLogosContainer : No images to show");
            }
        });
    } errorBlock:^(NSError *error) {
       
    }];
    
}

- (void)setLogosService:(PBBABankLogosService *)logosService {
    _logosService = logosService;
}

@end
