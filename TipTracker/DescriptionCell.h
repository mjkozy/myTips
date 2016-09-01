//
//  DescriptionCell.h
//  myTips
//
//  Created by Michael Kozy on 6/16/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"


@class Entry;

@interface DescriptionCell : UITableViewCell


@property Entry *entries;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;



@end
