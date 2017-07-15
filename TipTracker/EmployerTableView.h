//
//  EmployerTableView.h
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
//#import <CoreData/CoreData.h>
//#import "Employer.h"
#import "TipsTableViewController.h"

@interface EmployerTableView : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;



@end
