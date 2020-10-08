//
//  PBBAPopupContainerController.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/3/16.
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

#import "PBBAPopupContainerController.h"

@interface PBBAPopupContainerController ()

@end

@implementation PBBAPopupContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(PBBAPopupContentViewController *)viewController
{
    if(self.activeViewController)
    {
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController removeFromParentViewController];
    }
    self.activeViewController = viewController;
    [self addChildViewController:self.activeViewController];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController.view setFrame:self.view.frame];
    if (@available(iOS 11, *))
    {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        self.activeViewController.view.frame = guide.layoutFrame;
    }
    [self.activeViewController didMoveToParentViewController:self];
}

@end
