//
//  DetailViewController.m
//  myTips
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNeedsStatusBarAppearanceUpdate];
    
    self.dateLabel.text = [self.getRecord valueForKey:@"createdAt"];
    self.currentEmployerLabel.text = [self.getRecord valueForKey:@"employer"];
    self.spendingCashLabel.text = [NSString stringWithFormat:@"Spending Cash: %@",[self.getRecord valueForKey:@"spendingCash"]];
    self.salesLabel.text = [NSString stringWithFormat:@"Total Sales: %@",[self.getRecord valueForKey:@"totalSales"]];
    self.tipsLabel.text = [NSString stringWithFormat:@"Total Tips: %@",[self.getRecord valueForKey:@"totalTips"]];
    self.percentLabel.text = [NSString stringWithFormat:@"You earned %@ of sales",[self.getRecord valueForKey:@"percentEarned"]];
    self.expensesLabel.text = [NSString stringWithFormat:@"Set aside %@ for bills",[self.getRecord valueForKey:@"expenses"]];
    self.taxesLabel.text = [NSString stringWithFormat:@"Set aside %@ for taxes",[self.getRecord valueForKey:@"taxes"]];
    self.savingsLabel.text = [NSString stringWithFormat:@"Set aside %@ for savings",[self.getRecord valueForKey:@"savings"]];
    self.notesLabel.text = [self.getRecord valueForKey:@"notes"];

    UISwipeGestureRecognizer *swipeToClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [swipeToClose setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:swipeToClose];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.animator removeAllBehaviors];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
