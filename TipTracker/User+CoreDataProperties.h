//
//  User+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 2/6/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) Employer *employer;

@end

NS_ASSUME_NONNULL_END
