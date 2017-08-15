//
//  Entry+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 8/10/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "Entry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createdAt;
@property (nullable, nonatomic, copy) NSString *expenses;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *percentEarned;
@property (nullable, nonatomic, copy) NSString *savings;
@property (nullable, nonatomic, copy) NSString *spendingCash;
@property (nullable, nonatomic, copy) NSString *taxes;
@property (nullable, nonatomic, copy) NSString *totalSales;
@property (nullable, nonatomic, copy) NSString *totalTips;
@property (nullable, nonatomic, retain) Employer *currentEmployer;

@end

NS_ASSUME_NONNULL_END
