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
@interface TipsTableViewController : UITableViewController

@property DescriptionCell *cell;
@property (strong, nonatomic) Employer *recievedRecord;
@property (weak, nonatomic) IBOutlet UITableView *tipsTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;






@end
