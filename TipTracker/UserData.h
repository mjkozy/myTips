//
//  UserData.h
//  myTips
//
//  Created by Michael Kozy on 12/5/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject
@property (weak, nonatomic) NSString *date;
@property (weak, nonatomic) NSString *spendingCash;
@property (weak, nonatomic) NSString *sales;
@property (weak, nonatomic) NSString *tips;
@property (weak, nonatomic) NSString *percent;
@property (weak, nonatomic) NSString *expenses;
@property (weak, nonatomic) NSString *taxes;
@property (weak, nonatomic) NSString *savings;
@property (weak, nonatomic) NSString *notes;


@end
