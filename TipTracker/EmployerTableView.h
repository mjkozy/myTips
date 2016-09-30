//
//  EmployerTableView.h
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>


@interface EmployerTableView : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFRelation *employerRelation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;



@end
