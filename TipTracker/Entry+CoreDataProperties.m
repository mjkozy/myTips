//
//  Entry+CoreDataProperties.m
//  myTips
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
}

@dynamic createdAt;
@dynamic expenses;
@dynamic notes;
@dynamic percentEarned;
@dynamic savings;
@dynamic spendingCash;
@dynamic taxes;
@dynamic totalSales;
@dynamic totalTips;
@dynamic employer;

@end
