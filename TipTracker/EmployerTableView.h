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


@interface EmployerTableView : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEmployer;
@property (strong, nonatomic) NSManagedObjectContext *moc;


@end
