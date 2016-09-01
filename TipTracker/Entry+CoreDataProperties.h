//
//  Entry+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 8/25/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry.h"
#import "Employer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *percentEarned;
@property (nullable, nonatomic, retain) NSNumber *totalSales;
@property (nullable, nonatomic, retain) NSNumber *totalTips;
@property (nullable, nonatomic, retain) Employer *employers;

@end

NS_ASSUME_NONNULL_END
