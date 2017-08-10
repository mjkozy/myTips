//
//  DescriptionCell.h
//  myTips
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DescriptionCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;




@end
