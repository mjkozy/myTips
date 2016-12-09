//
//  TipsTableViewController.h
//  TipTracker
//
//  Created by Michael Kozy on 3/2/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DescriptionCell.h"
#import "Entry.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"
#import "UserData.h"



@class DescriptionCell;
@interface TipsTableViewController : UITableViewController

@property DescriptionCell *cell;
@property Entry *entry;
@property (weak, nonatomic) IBOutlet UITableView *tipsTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end
