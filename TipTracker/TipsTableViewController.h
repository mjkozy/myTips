//
//  TipsTableViewController.h
//  TipTracker
//
//  Created by Michael Kozy on 3/2/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DescriptionCell.h"
#import "Employer.h"
#import <Parse/Parse.h>





@interface TipsTableViewController : UITableViewController

@property Employer *employer;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
