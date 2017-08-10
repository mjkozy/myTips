//
//  EmployerViewController.h
//  myTips
//
//  Created by Michael Kozy on 8/10/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Employer+CoreDataClass.h"
#import "TipsTableViewController.h"


@interface EmployerViewController : UIViewController <UITableViewDataSource,UITabBarDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end
