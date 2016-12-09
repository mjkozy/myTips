//
//  DescriptionCell.h
//  myTips
//
//  Created by Michael Kozy on 6/16/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DescriptionCell : UITableViewCell


@property (strong, nonatomic) PFObject *entries;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentEarnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *expensesLabel;
@property (weak, nonatomic) IBOutlet UILabel *savingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendingCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxesLabel;



@end
