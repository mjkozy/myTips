//
//  UpdateMethods.h
//  myTips
//
//  Created by Michael Kozy on 10/14/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Entry.h"
#import <CoreData/CoreData.h>
#import "TipsTableViewController.h"

@interface UpdateMethods : NSObject
@property NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *ytdTipsData;

@end
