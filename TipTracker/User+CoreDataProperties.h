//
//  User+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 8/25/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"
#import "Employer.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstname;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) Employer *employers;

@end

NS_ASSUME_NONNULL_END
