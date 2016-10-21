//
//  UpdateMethods.m
//  myTips
//
//  Created by Michael Kozy on 10/14/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "UpdateMethods.h"


@implementation UpdateMethods


- (void)sumTips {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *tipDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalTips" ascending:NO];
    request.sortDescriptors = @[tipDescriptor];
    NSArray *ytdTips = [self.managedObjectContext executeFetchRequest:request error:nil];
    self.ytdTipsData = [NSMutableArray arrayWithArray:ytdTips];
    float total = 0;
    for (Entry *entry in self.ytdTipsData) {
        total += [entry.totalTips floatValue];
        NSNumber *ytdNumber = [NSNumber numberWithFloat:total];
        TipsTableViewController *tipsTVC = [TipsTableViewController new];
        tipsTVC.navigationItem.title = [NSString stringWithFormat:@"YTD: $%.2f", [ytdNumber floatValue]];
    }
}

@end
