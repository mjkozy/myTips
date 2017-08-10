//
//  Employer+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 8/10/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "Employer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employer (CoreDataProperties)

+ (NSFetchRequest<Employer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *employerName;
@property (nullable, nonatomic, retain) NSSet<Entry *> *entries;

@end

@interface Employer (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet<Entry *> *)values;
- (void)removeEntries:(NSSet<Entry *> *)values;

@end

NS_ASSUME_NONNULL_END
