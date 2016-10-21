//
//  DescriptionCell.m
//  myTips
//
//  Created by Michael Kozy on 6/16/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "DescriptionCell.h"


@interface DescriptionCell ()


@end


@implementation DescriptionCell



- (void)setCellView:(UIView *)cellView {

    
}

- (void)setEntry:(PFObject *)newEntry {

    if (newEntry != _entries) {
        _entries = newEntry;
    }
    self.dateLabel.text = [_entries objectForKey:@"date"];
    self.dateLabel.numberOfLines = 2;
    self.tipsAmountLabel.text = [_entries objectForKey:@"totalSales"];
    self.salesAmountLabel.text = [_entries objectForKey:@"totalTips"];
    self.percentEarnedLabel.text = [_entries objectForKey:@"percentEarned"];
    self.notesLabel.text = [_entries objectForKey:@"notes"];
    self.billsLabel.text = [_entries objectForKey:@"expenses"];
    self.savingsLabel.text = [_entries objectForKey:@"savings"];
    self.spendingCashLabel.text = [_entries objectForKey:@"spendingCash"];
    self.taxesLabel.text = [_entries objectForKey:@"taxes"];
}

@end
