//
//  TipsTableViewController.m
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
@property (strong, nonatomic) NSMutableArray *employerData;
@property (strong, nonatomic) NSMutableArray *entryData;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addInfoButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TipsTableViewController
@dynamic refreshControl;
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.mainTableView.separatorColor = [UIColor blackColor];

    UIImage *image = [UIImage imageNamed:@"appbackground.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.mainTableView.backgroundView = backgroundImage;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchEmployerData) forControlEvents:UIControlEventValueChanged];


//    self.navigationItem.title = @"MyTips";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchEmployerData];

}

//- (void)fetchEntryData {
//    NSManagedObjectContext *context = self.managedObjectContext;
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
//    NSSortDescriptor *tips = [[NSSortDescriptor alloc] initWithKey:@"totalTips" ascending:NO];
//    [request setEntity:entity];
//    request.sortDescriptors = @[tips];
//    NSArray *tipResults = [context executeFetchRequest:request error:nil];
//    self.entryData = [NSMutableArray arrayWithArray:tipResults];
//    float total;
//    for (Entry *tips in self.entryData) {
//        total += [tips.totalTips floatValue];
//        NSNumber *ytd = [NSNumber numberWithFloat:total];
//        self.navigationItem.title = [NSString stringWithFormat:@"$%.2f", [ytd floatValue]];
//    }
//}

//- (void)fetchEmployerData {
//    NSManagedObjectContext *context = self.managedObjectContext;
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:context];
//    [request setEntity:entity];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"employerName" ascending:YES]];
//    NSArray *temp = [context executeFetchRequest:request error:nil];
//    self.employerData = [NSMutableArray arrayWithArray:temp];
//
////    for (User *emp in self.userData) {
////        [self.managedObjectContext deleteObject:emp];
////        [self.managedObjectContext save:nil];
////          NSLog(@"Deleted: %@", emp);
////    }
//
//}

- (void)fetchEmployerData {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query whereKey:@"employee" equalTo:user];
    [query orderByAscending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            self.entryData = [[NSMutableArray alloc] initWithArray:objects];
            float total;
            for (PFObject *obj in self.employerData) {
                total += [[obj objectForKey:@"totalTips"] floatValue];
                NSString *ytd = [NSString stringWithFormat:@"$%.2f", total];
                self.navigationItem.title = ytd;
                NSLog(@"%@",objects);
                 [self.mainTableView reloadData];
            }
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.entryData.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.entryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DescriptionCell *cell = (DescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
//    Entry *entries = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PFObject *entries = [self.entryData objectAtIndex:indexPath.row];
    cell.dateLabel.text = [entries objectForKey:@"date"];
    cell.tipsLabel.text = [NSString stringWithFormat:@"Tips: $%@", [entries objectForKey:@"totalTips"]];
    cell.salesLabel.text = [NSString stringWithFormat:@"Sales: $%@", [entries objectForKey:@"totalSales"]];

    return cell;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        PFObject *deleteObject = [self.employerData objectAtIndex:indexPath.row];
        [deleteObject deleteInBackgroundWithBlock:nil];
        [deleteObject saveInBackgroundWithBlock:nil];
    }

}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        DetailsTableViewController *detailVC = (DetailsTableViewController *)nav.topViewController;
        NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
        Entry *entry = [self.entryData objectAtIndex:indexPath.row];
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
