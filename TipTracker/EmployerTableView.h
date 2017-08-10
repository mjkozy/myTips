//
//  EmployerTableView.h
//  TipTracker
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Employer+CoreDataClass.h"
#import "TipsTableViewController.h"

@interface EmployerTableView : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;




@end
