//
//  Employer+CoreDataProperties.m
//  myTips
//
//  Created by Michael Kozy on 8/10/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "Employer+CoreDataProperties.h"

@implementation Employer (CoreDataProperties)

+ (NSFetchRequest<Employer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employer"];
}

@dynamic employerName;
@dynamic entries;

@end
