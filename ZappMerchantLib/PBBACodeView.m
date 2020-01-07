//
//  PBBACodeView.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 15/07/2015.
//  Copyright 2016 IPCO 2012 Limited
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

#import "PBBACodeView.h"
#import "NSBundle+ZPMLib.h"
#import "PBBAExpiryTimer.h"
#import "UIFont+ZPMLib.h"

@interface PBBACodeView() <PBBAExpiryTimerDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *zappCodeLabelCollection;

@property (weak, nonatomic) IBOutlet UILabel *brnTimerLabel;

@property (strong,nonatomic) PBBAExpiryTimer* timer;
@property (weak, nonatomic) IBOutlet UIView *brnAccessibilityReferenceView;
@property (weak, nonatomic) IBOutlet UIView *brnCodeView;
@property (weak, nonatomic) IBOutlet UIView *timerHolderView;

@end

@implementation PBBACodeView

-(instancetype) initWithBRN: (NSString*) brn
          andExpiryInterval: (NSUInteger)expiryInterval{
    if (self = [super init]){
        self = [[[NSBundle pbba_merchantResourceBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        self.brn = brn;
        self.expiryInterval = expiryInterval;
        self.brnTimerLabel.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
        self.shouldGroupAccessibilityChildren = YES;
        if (_brnAccessibilityReferenceView && _brnCodeView && _timerHolderView) {
            self.accessibilityElements = @[_brnAccessibilityReferenceView,_brnCodeView,_timerHolderView];
        }
    };
    
    return self;
}

-(void)setBrn:(NSString *)brn
andExpiryInterval: (NSUInteger) expiryInterval {
    [self setBrn:brn];
    [self setExpiryInterval:expiryInterval];
}

-(void)setExpiryInterval:(NSUInteger)expiryInterval {
    _expiryInterval = expiryInterval;
    self.brnTimerLabel.text =  [NSString stringWithFormat:@"%lu",(unsigned long)self.expiryInterval];
    self.timer = [[PBBAExpiryTimer alloc] initWithExpiryInterval:self.expiryInterval];
    self.timer.subscriber = self ;
}


- (void)setBrn:(NSString *)brn
{
    _brn = brn;
    
    __block NSRange range;
    
    range.length = 1;
    
    NSAssert(brn.length == self.zappCodeLabelCollection.count,
             @"PBBACodeView: Unbalanced BRN: %@ length with label outlet collection length: %tu", brn, self.zappCodeLabelCollection.count);
        
    [self.zappCodeLabelCollection enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        
        range.location = idx;
        
        NSString *letter = [brn substringWithRange:range];
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 3.5;
        label.text = letter;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont pbba_heavyFontWithSize:14];
        label.minimumFontSize = 6;
        label.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
              
               if ([letter rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                   label.accessibilityLabel = letter;
               } else {
                   label.accessibilityLabel = [NSString stringWithFormat:@"CAPITAL %@", letter];
               }

    }];
}

#pragma mark - PBBAExpiryTimerDelegate

- (void)timerDidUpdateWithValue:(NSUInteger)timerValue
{
    self.brnTimerLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)timerValue];
    if (timerValue<=30) {
        [self.brnTimerLabel setBackgroundColor:[UIColor redColor]];
    }
}

-(void)timerExpired {
    if ([self.subscriber respondsToSelector:@selector(codeViewExpired)]) {
        [self.subscriber codeViewExpired];
    }
}

@end
