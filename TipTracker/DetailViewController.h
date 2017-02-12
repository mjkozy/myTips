//
//  DetailViewController.h
//  myTips
//
//  Created by Michael Kozy on 12/6/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendingCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *expensesLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxesLabel;
@property (weak, nonatomic) IBOutlet UILabel *savingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;



@end
