//
//  TipsViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/2/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "InputDataView.h"
#import "DetailsTableViewController.h"
#import "TipsTableViewController.h"
#import "AppDelegate.h"




@interface TipsTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *entryObjects;
@property (strong, nonatomic) NSArray *entryData;
@property (strong, nonatomic) NSArray *currentEmployerName;
@property (strong, nonatomic) NSMutableArray *ytdTipsData;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEntryButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TipsTableViewController
@dynamic refreshControl;
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    UIImage *mainBackGroundImage = [UIImage imageNamed:@"splashPage.png"];
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainBackGroundImage];
    self.tipsTableView.backgroundView = mainImageView;
    self.tipsTableView.backgroundColor = [UIColor grayColor];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchEntryData) forControlEvents:UIControlEventValueChanged];

//    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
//    [query whereKey:@"user" equalTo:user];
//    [query findObjectsInBackgroundWithBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *user = [PFUser currentUser];
    if (user) {
        NSLog(@"%@", user.username);
    }
    [self fetchEntryData];
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.currentEmployerName = [NSArray arrayWithObject:objects];
            NSLog(@"%@", self.currentEmployerName);
        }
    }];
}

- (IBAction)didTapAddEntryButton:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Employer" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Employer";
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *newSales = [[alertController textFields]firstObject];
        UITextField *newTips = [[alertController textFields]lastObject];

        NSString *newSalesString = newSales.text;
        NSString *newTipsString = newTips.text;
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        PFObject *entryObject = [self.entryObjects objectAtIndex:indexPath.row];
        [entryObject addObject:newSalesString forKey:@"totalSales"];
        [entryObject addObject:newTipsString forKey:@"totalTips"];
//        [object setObject:[PFUser currentUser] forKey:@"userId"];

        [entryObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Cannot save at this time");
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)deleteAllButtonTapped:(id)sender {
    PFQuery *deleteAll = [PFQuery queryWithClassName:@"Entries"];
    PFUser *currentUser = [PFUser currentUser];
    [deleteAll whereKey:@"createdBy" equalTo:currentUser];
    [deleteAll findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        UIAlertController *deleteController = [UIAlertController alertControllerWithTitle:@"Delete all entries?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (PFObject *deleteObj in self.entryObjects) {
                [deleteObj deleteInBackground];
                  [self.tipsTableView reloadData];
            }

        }];
        [deleteController addAction:okayAction];
        [self presentViewController:deleteController animated:YES completion:^{

        }];
    }];
}

- (void)fetchEntryData {
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query whereKey:@"createdBy" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.entryData = objects;
            self.entryObjects = [NSMutableArray arrayWithArray:self.entryData];
            [self.tipsTableView reloadData];

        }else {
             NSLog(@"Cannot get data at this time");
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

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
        self.navigationItem.title = [NSString stringWithFormat:@"YTD: $%.2f", [ytdNumber floatValue]];
    }
}

#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.entryObjects.count;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    PFUser *currentUser = [PFUser currentUser];
    return [currentUser objectForKey:@"currentEmployer"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.backgroundColor = [UIColor blackColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    PFUser *currentUser = [PFUser currentUser];
    headerLabel.text = [currentUser objectForKey:@"currentEmployer"];

    [headerView addSubview:headerLabel];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];

    cell.backgroundColor = [UIColor clearColor];

    PFObject *entries = [self.entryObjects objectAtIndex:indexPath.row];
    cell.dateLabel.text = [entries objectForKey:@"date"];
    cell.tipsAmountLabel.text = [NSString stringWithFormat:@" %@",[entries objectForKey:@"totalTips"]];
    cell.salesAmountLabel.text = [NSString stringWithFormat:@" %@",[entries objectForKey:@"totalSales"]];
    cell.notesLabel.text = [entries objectForKey:@"notes"];
    cell.percentEarnedLabel.text = [NSString stringWithFormat:@" %@",[entries objectForKey:@"percentEarned"] ];

        return cell;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.entryObjects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    PFObject *deleteObject = [self.entryObjects objectAtIndex:indexPath.row];
        [deleteObject deleteInBackground];
        [deleteObject saveInBackground];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailsTableViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        PFObject *entry = [self.entryObjects objectAtIndex:indexPath.row];
        detailVC.entries = entry;
    }
    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
        UINavigationController *inputNav = segue.destinationViewController;
        InputDataView *inputVC = (InputDataView *)inputNav.topViewController;
        NSLog(@"%@", inputVC);
    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
        InputDataView *inputVC;
        inputVC = segue.sourceViewController;
    }if ([segue.identifier isEqualToString:@"signUpSegue"]) {
        SignUpViewController *signUP;
        signUP = segue.sourceViewController;
    }
}


@end
