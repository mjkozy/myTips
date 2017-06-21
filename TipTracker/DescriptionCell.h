//
//  DescriptionCell.h
//  myTips
//
//  Created by Michael Kozy on 6/16/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DescriptionCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;




@end
