//
//  NavigationViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/25/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()<UINavigationControllerDelegate, UINavigationBarDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
