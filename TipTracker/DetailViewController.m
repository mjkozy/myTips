//
//  DetailViewController.m
//  myTips
//
//  Created by Michael Kozy on 12/6/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
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

    self.dateLabel.text = _userData.date;
    self.spendingCashLabel.text = _userData.spendingCash;
    self.salesLabel.text = _userData.sales;
    self.tipsLabel.text = _userData.tips;
    self.percentLabel.text = _userData.percent;
    self.expensesLabel.text = _userData.expenses;
    self.taxesLabel.text = _userData.taxes;
    self.savingsLabel.text = _userData.savings;
    self.notesLabel.text = _userData.notes;

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
