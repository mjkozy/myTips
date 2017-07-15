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
    
    self.title = [self.getRecord objectForKey:@"employer"];
    self.dateLabel.text = [self.getRecord objectForKey:@"dateEntered"];
    self.currentEmployerLabel.text = [self.getRecord objectForKey:@"empName"];
    self.spendingCashLabel.text = [NSString stringWithFormat:@"Spending Cash: %@",[self.getRecord objectForKey:@"spendingCash"]];
    self.salesLabel.text = [NSString stringWithFormat:@"Total Sales: %@",[self.getRecord objectForKey:@"totalSales"]];
    self.tipsLabel.text = [NSString stringWithFormat:@"Total Tips: %@",[self.getRecord objectForKey:@"totalTips"]];
    self.percentLabel.text = [NSString stringWithFormat:@"You earned %@ of sales",[self.getRecord objectForKey:@"percentEarned"]];
    self.expensesLabel.text = [NSString stringWithFormat:@"Set aside %@ for bills",[self.getRecord objectForKey:@"expenses"]];
    self.taxesLabel.text = [NSString stringWithFormat:@"Set aside %@ for taxes",[self.getRecord objectForKey:@"taxes"]];
    self.savingsLabel.text = [NSString stringWithFormat:@"Set aside %@ for savings",[self.getRecord objectForKey:@"savings"]];
    self.notesLabel.text = [self.getRecord objectForKey:@"notes"];

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
