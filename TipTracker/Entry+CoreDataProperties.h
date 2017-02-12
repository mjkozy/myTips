//
//  Entry+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 2/6/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//


#import "Employer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *expenses;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *percentEarned;
@property (nullable, nonatomic, retain) NSString *savings;
@property (nullable, nonatomic, retain) NSString *spendingCash;
@property (nullable, nonatomic, retain) NSString *taxes;
@property (nullable, nonatomic, retain) NSString *totalSales;
@property (nullable, nonatomic, retain) NSString *totalTips;
@property (nullable, nonatomic, retain) Employer *employer;

@end

NS_ASSUME_NONNULL_END
