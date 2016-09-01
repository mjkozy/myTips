//
//  DetailsTableViewController.m
//  myTips
//
//  Created by Michael Kozy on 8/3/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "DetailsTableViewController.h"
#import <Parse/Parse.h>



@interface DetailsTableViewController ()
@property (strong, nonatomic)NSArray *details;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *percent;

@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.employerLabel.text = _entries.employers.employerName;
    self.dateLabel.text = _entries.createdAt;
    self.totalTipsLabel.text = [NSString stringWithFormat:@"$%.2f", [_entries.totalTips floatValue]];
    self.totalSalesLabel.text = [NSString stringWithFormat:@"$%.2f",[_entries.totalSales floatValue] ];
    self.percentageLabel.text = _entries.percentEarned;

    self.navigationItem.title = @"Details";
    self.notesLabel.text = _entries.notes;

    if ([self.percentageLabel.text floatValue] >= 0.20) {
        self.detailView.backgroundColor = [UIColor greenColor];

        [self performSelector:@selector(removeLabel) withObject:nil afterDelay:2.0];
    }else {
        self.detailView.backgroundColor = [UIColor redColor];
        self.percentageLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(removeLabel) withObject:nil afterDelay:2.0];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.animator removeAllBehaviors];
    }];
}

- (void)removeLabel {
    //fade out sales, percent and notes labels with 1 second animations
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.sales setAlpha:0];
    [self.totalSalesLabel setAlpha:0];
    [self.dateLabel setAlpha:0];
    [self.percent setAlpha:0];
    [self.percentageLabel setAlpha:0];
    [self.employerLabel setAlpha:0];
    [self.notesLabel setAlpha:0];
    [UIView commitAnimations];
}

@end
