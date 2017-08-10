//
//  TipsTableViewController.h
//  TipTracker
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EmployerTableView.h"
#import "DescriptionCell.h"
#import "DetailViewController.h"
#import "Entry+CoreDataClass.h"
#import <CloudKit/CloudKit.h>



//@class Entry;
@class DescriptionCell;
@interface TipsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property DescriptionCell *cell;
@property (strong, nonatomic) Employer *recievedRecord;
@property (strong, nonatomic) NSString *empName;
@property (weak, nonatomic) IBOutlet UITableView *tipsTableView;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;







@end
