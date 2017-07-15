//
//  TipsTableViewController.h
//  TipTracker
//
//  Created by Michael Kozy on 3/2/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
#import "DescriptionCell.h"
//#import "Entry.h"
#import "DetailViewController.h"
#import <CloudKit/CloudKit.h>
//#import "Employer.h"


//@class Entry;
@class DescriptionCell;
@interface TipsTableViewController : UITableViewController

@property DescriptionCell *cell;
@property (strong, nonatomic) CKRecord *recievedRecord;
@property (weak, nonatomic) IBOutlet UITableView *tipsTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;






@end
