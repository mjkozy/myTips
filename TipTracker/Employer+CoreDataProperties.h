//
//  Employer+CoreDataProperties.h
//  myTips
//
//  Created by Michael Kozy on 6/6/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Employer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Employer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *employerName;
@property (nullable, nonatomic, retain) User *employee;
@property (nullable, nonatomic, retain) NSOrderedSet<Entry *> *entries;

@end

@interface Employer (CoreDataGeneratedAccessors)

- (void)insertObject:(Entry *)value inEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEntriesAtIndex:(NSUInteger)idx;
- (void)insertEntries:(NSArray<Entry *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEntriesAtIndex:(NSUInteger)idx withObject:(Entry *)value;
- (void)replaceEntriesAtIndexes:(NSIndexSet *)indexes withEntries:(NSArray<Entry *> *)values;
- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSOrderedSet<Entry *> *)values;
- (void)removeEntries:(NSOrderedSet<Entry *> *)values;

@end

NS_ASSUME_NONNULL_END
