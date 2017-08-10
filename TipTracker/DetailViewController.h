//
//  DetailViewController.h
//  myTips
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsTableViewController.h"
#import <CloudKit/CloudKit.h>
#import "Entry+CoreDataClass.h"

@interface DetailViewController : UIViewController


@property (strong, nonatomic) Entry *getRecord;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendingCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *expensesLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxesLabel;
@property (weak, nonatomic) IBOutlet UILabel *savingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentEmployerLabel;



@end
