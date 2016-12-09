//
//  DetailsTableViewController.h
//  myTips
//
//  Created by Michael Kozy on 12/4/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsTableViewController.h"


@interface DetailTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;
@property NSMutableArray *details;


@end
