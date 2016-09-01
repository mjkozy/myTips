//
//  DetailsTableViewController.h
//  myTips
//
//  Created by Michael Kozy on 8/3/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@class User;

@interface DetailsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UINavigationItem *backButton;
@property (weak, nonatomic) IBOutlet UILabel *employerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSalesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property User *employee;
@property Entry *entries;

@end
