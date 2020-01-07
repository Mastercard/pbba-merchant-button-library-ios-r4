//
//  PBBAMoreAboutViewController.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 06/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBAMoreAboutViewController.h"
#import "NSBundle+ZPMLib.h"
#import "UIColor+ZPMLib.h"
#import "UIFont+ZPMLib.h"
#import "NSAttributedString+ZPMLib.h"
#import "PBBABankLogosContainer.h"
#import "PBBABankLogosService.h"

@interface PBBAMoreAboutViewController ()

@property (nonatomic, strong) PBBABankLogosService *logosService;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *roundLabels;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel1;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel2;
@property (weak, nonatomic) IBOutlet UILabel *howItWorks;
@property (weak, nonatomic) IBOutlet UILabel *howItWorksLabel1;
@property (weak, nonatomic) IBOutlet UILabel *howItWorksLabel2;
@property (weak, nonatomic) IBOutlet UILabel *howItWorksLabel3;
@property (weak, nonatomic) IBOutlet PBBABankLogosContainer *bankLogosView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation PBBAMoreAboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:[NSBundle pbba_merchantResourceBundle]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;

    NSString *boldFragment = PBBALocalizedString(@"com.zapp.moreAboutPopup.howItWorks1Bold");

    float fontSize = 17.0f;

    NSAttributedString *howItWorksStep1 = [NSAttributedString pbba_highlightFragments:@[boldFragment]
                                                           inText:PBBALocalizedString(@"com.zapp.moreAboutPopup.howItWorks1")
                                                         withFont:[UIFont pbba_regularFontWithSize:fontSize]
                                                   hightlightFont:[UIFont pbba_boldFontWithSize:fontSize]
                                                        alignment:NSTextAlignmentLeft];

    _howItWorksLabel1.attributedText = howItWorksStep1;
    _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1");
//    _informationLabel2.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information2");
    _howItWorks.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.howItWorks");
    _howItWorksLabel2.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.howItWorks2");
    _howItWorksLabel3.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.howItWorks3");
    
    [self adjustFontSizeFor:_howItWorksLabel1];
    [self updateLabelForDeviceOrientation];
    [self.bankLogosView setLogosService:self.popupCoordinator.logosService];
    
    [self.roundLabels enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor pbba_pbbaBrandColor];
        obj.layer.cornerRadius = 25;
        obj.clipsToBounds = YES;
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (@available(iOS 11, *))
    {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        self.contentView.frame = guide.layoutFrame;
    }

}

-(void)adjustFontSizeFor:(UILabel*)label
{
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.minimumFontSize = 2;
    label.lineBreakMode = UILineBreakModeClip;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (size.width > size.height)
        {
            [self.scrollView setContentOffset:self.topView.bounds.origin];
            _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.landscape");
            _informationLabel1.textAlignment = NSTextAlignmentLeft;
            _informationLabel2.textAlignment = NSTextAlignmentLeft;
            _howItWorks.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.portrait");
            _informationLabel1.textAlignment = NSTextAlignmentCenter;
            _informationLabel2.textAlignment = NSTextAlignmentCenter;
            _howItWorks.textAlignment = NSTextAlignmentCenter;
        }
    }
    if (size.width > size.height)
    {
        _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.landscape");
    }
}

-(void)updateLabelForDeviceOrientation
{
    UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _informationLabel1.textAlignment = NSTextAlignmentLeft;
        _informationLabel2.textAlignment = NSTextAlignmentLeft;
        _howItWorks.textAlignment = NSTextAlignmentLeft;
        _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.landscape");
    }
    else
    {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationLandscapeRight) | (statusBarOrientation == UIInterfaceOrientationLandscapeLeft))
        {
            _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.landscape");
            _informationLabel1.textAlignment = NSTextAlignmentLeft;
            _informationLabel2.textAlignment = NSTextAlignmentLeft;
            _howItWorks.textAlignment = NSTextAlignmentLeft;
        }
        else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) | (statusBarOrientation == UIInterfaceOrientationPortrait))
        {
            _informationLabel1.text = PBBALocalizedString(@"com.zapp.moreAboutPopup.information1.portrait");
            _informationLabel1.textAlignment = NSTextAlignmentCenter;
            _informationLabel2.textAlignment = NSTextAlignmentCenter;
            _howItWorks.textAlignment = NSTextAlignmentCenter;
        }
    }
}

- (IBAction)closePopup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"PBBAMoreAboutViewController:  popup dissmised");
    }];
}

#pragma mark - Scroll View delegates
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.topView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
