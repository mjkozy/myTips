//
//  DetailTableViewController.m
//  myTips
//
//  Created by Michael Kozy on 12/4/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "DetailTableViewController.h"
#import <Parse/Parse.h>

@interface DetailTableViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    UITableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
    UITableViewCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell"];
    UITableViewCell *fourthCell = [tableView dequeueReusableCellWithIdentifier:@"fourthCell"];
    PFObject *detailObj = [self.details objectAtIndex:indexPath.row];
    firstCell.textLabel.text = [detailObj objectForKey:@"totalSales"];
    firstCell.detailTextLabel.text = [detailObj objectForKey:@"totalTips"];
    secondCell.textLabel.text = [detailObj objectForKey:@"percentEarned"];
    secondCell.detailTextLabel.text = [detailObj objectForKey:@"savings"];
    thirdCell.textLabel.text = [detailObj objectForKey:@"expenses"];
    thirdCell.detailTextLabel.text = [detailObj objectForKey:@"taxes"];
    fourthCell.textLabel.text = [detailObj objectForKey:@"notes"];
    fourthCell.detailTextLabel.text = [detailObj objectForKey:@"spendingCash"];

    return firstCell;
    return secondCell;
    return thirdCell;
    return fourthCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
