//
//  PBBAMoreAboutBankLogostContainer.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 10/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBABankLogosContainer.h"
#import "NSBundle+ZPMLib.h"
#import "UIView+ZPMLib.h"
#import "PBBABankLogo.h"

#define kPBBABankLogosLayoutNibName @"PBBABankLogosLayouts"

@interface PBBABankLogosContainer ()


@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (weak, nonatomic) IBOutlet UIView *logosContainerView;
@property(strong, nonatomic) PBBABankLogosService *logosService;
@end

@implementation PBBABankLogosContainer

- (void) layoutLayout: (UIView*) logosLayout {
    logosLayout.translatesAutoresizingMaskIntoConstraints = NO;
    [logosLayout pbba_pinToSuperviewEdges];
    [logosLayout setNeedsLayout];
    [logosLayout layoutIfNeeded];
}

- (void) updateForImages: (NSArray*) images {
    UIView* logosLayout = [self loadLayoutForImages:images];
    if (logosLayout) {
        [self addImages:images toView:logosLayout];
        [_logosContainerView addSubview:logosLayout];
        [self layoutLayout:logosLayout];
    }
}

- (UIView *) loadLayoutForImages: (NSArray* ) images {
    NSString* nibName = kPBBABankLogosLayoutNibName;
    NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    
    NSInteger nrOfImages = images.count;
    
    if (nibPath) {
        NSArray* elements = [bundle loadNibNamed:nibName owner:nil options:nil];
        for (UIView* view in elements) {
            if (view.tag == nrOfImages) {
                return view;
            }
        }
    }
    self.hidden = YES;
    return nil;
}

- (void) addImages: (NSArray*) images toView: (UIView*) view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                PBBABankLogo* logo = self.logosService.logos[idx];
                NSData * data = [[NSData alloc] initWithContentsOfURL: logo.largeImageURL];
                if ( data == nil ) {
                    self.hidden = YES;
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView* imv = obj;
                    imv.image = [UIImage imageWithData: data];
                    //imv.layer.borderWidth = 0.5;
                    //imv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                    imv.layer.cornerRadius = 5.0;
                    imv.accessibilityLabel= logo.bankName;
                    imv.accessibilityValue = @"image";
                    
                });
            });
        }
    }];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    _availabilityLabel.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.logosContainerAvailability");
    [self updateLabelForDeviceOrientation];
    if (self.logosService.nrOfLogos > 0){
//        [self fillAlternativeViewForImages:self.logosService.logos];
        [self updateForImages:self.logosService.logos];
    } else {
        self.hidden = YES;
        NSLog(@"PBBABankLogosContainer : No images to show");
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (size.width > size.height) {
            _availabilityLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            _availabilityLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

-(void)updateLabelForDeviceOrientation
{
    UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _availabilityLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationLandscapeRight) | (statusBarOrientation == UIInterfaceOrientationLandscapeLeft)) {
            _availabilityLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationPortrait)) {
            _availabilityLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

- (void)setLogosService:(PBBABankLogosService *)logosService {
    _logosService = logosService;
}



#pragma mark - Alternative view

- (UIView *) alternativeLayoutForImages: (NSArray* ) images {
    NSString* nibName = @"PBBABankLogosCommonLayout";
    NSBundle *bundle = [NSBundle pbba_merchantResourceBundle];
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    
    if (nibPath) {
        NSArray* elements = [bundle loadNibNamed:nibName owner:nil options:nil];
        for (UIView* view in elements) {
                return view;
        }
    }
    self.hidden = YES;
    return nil;
}

- (void) fillAlternativeViewForImages: (NSArray* ) images {
    UIView* alternativeView = [self alternativeLayoutForImages:images];
   
    int index = 0;
    for (UIView* containerView in alternativeView.subviews) {
    
   // [alternativeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
  //      if ([view isKindOfClass:[UIView class]]) {
            for (UIImageView* imageView in containerView.subviews) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    PBBABankLogo* logo = self.logosService.logos[index];
                    NSData * data = [[NSData alloc] initWithContentsOfURL: logo.largeImageURL];
                    if ( data == nil )
                        return;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = [UIImage imageWithData: data];
                    });
                });
                
                if (index++ == images.count-1) break;
            }
        }
   // }];
    
    [_logosContainerView addSubview:alternativeView];
    [self layoutLayout:alternativeView];
}


@end
