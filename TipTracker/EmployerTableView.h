//
//  EmployerTableView.h
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "Employer.h"

@interface EmployerTableView : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFRelation *employerRelation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end
