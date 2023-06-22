//
//  PBBAAppPickerViewController.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 4/7/17.
//  Copyright 2017 Vocalink Limited
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

#import "PBBAAppPickerViewController.h"
#import "PBBAAppPickerAnimator.h"

#import "PBBAAppPickerItemCell.h"
#import "PBBAGradientView.h"

#import "PBBAAppPickerUtils.h"
#import "PBBAAppPickerService.h"
#import "PBBAAppPickerConfiguration.h"

#import "NSBundle+PBBAUtils.h"
#import "PBBAPopupViewController.h"
#import "PBBAPopupCoordinator.h"
#import "PBBAPopupContentViewController.h"

static CGSize PBBAAppPickerItemCellReferenceSize;

@interface PBBAAppPickerViewController () <UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURL *invocationURL;
@property (assign, nonatomic) NSString *schemeUsed;

@property (strong, nonatomic) PBBAAppPickerItem *hostAppPickerItem;

@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet PBBAGradientView *tableViewTopShadowView;

@property (strong, nonatomic) NSLayoutConstraint *tableViewHeightConstraint;

@property (strong, nonatomic) NSArray<PBBAAppPickerItem *> *appPickerItems;
@property (strong, nonatomic) PBBAAppPickerService *appPickerService;

@property (weak, nonatomic) IBOutlet UIView *appPickerView;

@end

@implementation PBBAAppPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set the view frame as the presenters view frame
    self.view.frame = self.presentingViewController.view.frame;
    self.appPickerService = [PBBAAppPickerService new];

    // Setup main view
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundView.layer.cornerRadius = 13.0f;
    self.backgroundView.alpha = 0.95f;
    self.backgroundView.clipsToBounds = YES;
    
    // Setup cancel button
    self.cancelButton.layer.cornerRadius = 13.0f;
    [self.cancelButton setTitle:PBBALocalizedString(@"com.pbba.cancel.button.title")
                       forState:UIControlStateNormal];
    
    // Setup table view
    PBBAAppPickerItemCellReferenceSize = CGSizeMake(320, 50);
  //  self.tableView.rowHeight = UITableViewAutomaticDimension;
    // self.tableView.estimatedRowHeight = PBBAAppPickerItemCellReferenceSize.height;
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 7;
    contentInset.top = 11;
    self.tableView.contentInset = contentInset;
    self.tableView.scrollIndicatorInsets = contentInset;
    self.tableViewTopShadowView.colors = @[PBBA_RGBA(243, 244, 244, 1), [UIColor colorWithWhite:1 alpha:0]];
    
    // Register app item cell
    UINib *cellNib = [UINib nibWithNibName:PBBAAppPickerItemCellIdentifier bundle:[NSBundle pbba_bundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:PBBAAppPickerItemCellIdentifier];
    
    // Load app picker items
    [self loadAppPickerItems];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
        
    // Calculate the table view height for max 3 items
    CGFloat maxHeight = self.view.frame.size.height/2;
    CGFloat tableViewHeight = (self.tableView.contentSize.height <= maxHeight)
        ? self.tableView.contentSize.height
        : maxHeight;

    tableViewHeight += self.tableView.contentInset.bottom + self.tableView.contentInset.top;

    tableViewHeight = (tableViewHeight <= maxHeight) ? tableViewHeight: maxHeight;
    
    [self.tableView removeConstraint:self.tableViewHeightConstraint];
    self.tableViewHeightConstraint =
        [NSLayoutConstraint constraintWithItem:self.tableView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:tableViewHeight];
    
    [self.tableView addConstraint:self.tableViewHeightConstraint];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewControllerWillAppear:)]) {
        [self.delegate pbbaAppPickerViewControllerWillAppear:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewControllerDidDisappear:)]) {
        [self.delegate pbbaAppPickerViewControllerDidDisappear:self];
    }
}

#pragma mark - Load App Picker Items

- (void)loadAppPickerItems
{
    [self showActivity:YES];
    [self.appPickerService getAppPickerItems:^(NSArray<PBBAAppPickerItem *> *items, NSError *error) {
        // Fail silently if there is an error when retrieving the app picker items.
        if (error) {
            // Notify delegate
            if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewController:didFailWithError:)]) {
                [self.delegate pbbaAppPickerViewController:self didFailWithError:error];
            }
            // Close app picker.
            [self closeAppPicker];
            return;
        }
        
        // Filter out the app picker items which are not installed on the device
        NSMutableArray<PBBAAppPickerItem *> *finalItems = [[PBBAAppPickerUtils filterAppPickerItemsForInstalledApps:items] mutableCopy];
        
        switch (self.requestType) {
            case PBBARequestTypeRequestToPay:
                // App Picker should show all the bank apps from the manifest file.
                break;
            case PBBARequestTypeRequestToLink:
            case PBBARequestTypeRequestToLinkAndPay:
                // App Picker should only show all the bank apps from the manifest file with API version greater than 3.
                finalItems = [[PBBAAppPickerUtils filterAppPickerItems:finalItems
                                                           requestType:self.requestType] mutableCopy];
                break;
        }

        if (finalItems.count == 1) {
            // Don't show app picker as there is only one PBBA enabled app installed
            [self continuePaymentForAppPickerItem:finalItems.firstObject];
            // Notify delegate
            if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewController:willShowAppPickerItems:)]) {
                [self.delegate pbbaAppPickerViewController:self willShowAppPickerItems:NO];
            }
        } else if (finalItems.count) {
            // Show app picker items if there is more than one PBBA enabled app installed
            self.appPickerView.hidden = NO;
            // Sort the items in ascending English alphabetical order
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"appName" ascending:YES];
            finalItems = [[finalItems sortedArrayUsingDescriptors:@[sort]] mutableCopy];
            
            // Notify delegate
            if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewController:willShowAppPickerItems:)]) {
                [self.delegate pbbaAppPickerViewController:self willShowAppPickerItems:YES];
            }
            
            // Show app picker items
            self.appPickerItems = finalItems;
            [self stopActivityAndShowItems];
        } else {
            // Notify delegate
            if ([self.delegate respondsToSelector:@selector(pbbaAppPickerViewController:willShowAppPickerItems:)]) {
                [self.delegate pbbaAppPickerViewController:self willShowAppPickerItems:NO];
            }
            [self showPBBAPopup];
        }
    }];
}

- (void)showPBBAPopup {
    
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"ZappMerchantLibResources" withExtension:@"bundle"];
    
    UIStoryboard *storyboardInstance = [UIStoryboard storyboardWithName:@"PBBAPopup"
                                                         bundle:[NSBundle bundleWithURL:bundleUrl]];
    PBBAPopupViewController *pbbaPopupVC = [storyboardInstance instantiateViewControllerWithIdentifier:@"PBBAPopupViewController"];
    pbbaPopupVC.expiryInterval = self.expiryInterval;
    [pbbaPopupVC setSecureToken:self.secureToken brn:self.brn requestType:self.requestType delegate:self.presenter];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.presenter presentViewController:pbbaPopupVC animated:YES completion:^{
            PBBAPopupContentViewController *eComVC = [storyboardInstance instantiateViewControllerWithIdentifier:@"PBBAPopupContentViewController"];
            eComVC.popupCoordinator = pbbaPopupVC.popupCoordinator;
            [eComVC updateForBRN:self.brn andExpiryInterval: self.expiryInterval];
            [pbbaPopupVC.containerViewController pushViewController:eComVC];
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self);
        }];
    }];
}

#pragma mark - App Picker Actions

- (void)showActivity:(BOOL)show
{
    if (show) {
        self.contentView.hidden = YES;
        self.activityView.hidden = NO;
    } else {
        self.activityView.hidden = YES;
        self.contentView.hidden = NO;
    }
}

- (void)stopActivityAndShowItems
{
    // Stop activity
    [self showActivity:NO];
    [self.activityView removeFromSuperview];
    
    // Reload data and prepare canvas update
    self.contentView.alpha = 0;
    [self.tableView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 1;
    }];
}

- (void)closeAppPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)continuePaymentForAppPickerItem:(PBBAAppPickerItem *)item
{
    [PBBAAppPickerUtils openAppForAppPickerItem:item secureToken:self.secureToken requestType:self.requestType];
    
    [self closeAppPicker];
}

- (IBAction)pbba_didPressCancelButton:(id)sender
{
    UIAlertController *alertC =
        [UIAlertController alertControllerWithTitle:PBBALocalizedString(@"com.pbba.cancel.alert.title")
                                            message:PBBALocalizedString(@"com.pbba.cancel.alert.message")
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction =
        [UIAlertAction actionWithTitle:PBBALocalizedString(@"com.pbba.cancel.alert.confirm")
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self closeAppPicker];
                                   });
                               }];
    
    UIAlertAction *yesAction =
        [UIAlertAction actionWithTitle:PBBALocalizedString(@"com.pbba.cancel.alert.decline")
                                 style:UIAlertActionStyleCancel
                               handler:nil];
    
    [alertC addAction:noAction];
    [alertC addAction:yesAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appPickerItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBBAAppPickerItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:PBBAAppPickerItemCellIdentifier];
    
    // Configure app picker item cell
    PBBAAppPickerItem *appPickerItem = self.appPickerItems[indexPath.row];
    itemCell.appNameLabel.text = appPickerItem.appName;
    itemCell.appNameLabel.textColor = UIColor.blackColor;
    itemCell.hideSeparator = (indexPath.row == self.appPickerItems.count - 1) ? YES : NO;
    
    // Async load of the app icon
    [self.appPickerService getAppIconWithURL:appPickerItem.appIconURL
                                 appIconHash:appPickerItem.appIconHash
                                  completion:^(UIImage *appIcon, NSError *error) {
                                      itemCell.appIconImageView.image = appIcon;
                                      itemCell.appIconImageView.accessibilityLabel = appPickerItem.appName;
                                  }];
    
    return itemCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self continuePaymentForAppPickerItem:self.appPickerItems[indexPath.row]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = (scrollView.contentOffset.y <= 0) ? 0 : 1;
    if (self.tableViewTopShadowView.alpha != alpha) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableViewTopShadowView.alpha = alpha;
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[PBBAAppPickerAnimator alloc] initWithAnimationType:PBBAAppPickerAnimationTypePresentation];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PBBAAppPickerAnimator alloc] initWithAnimationType:PBBAAppPickerAnimationTypeDismissal];
}

@end
