//
//  EmployerTableView.m
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import "TipsTableViewController.h"
#import "InputDataView.h"
#import "EmployerTableView.h"
#import "AppDelegate.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

@interface EmployerTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *employerName;


@property (weak, nonatomic) IBOutlet UITableView *employerTableView;


@end

@implementation EmployerTableView
@dynamic refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(retrieveEmployerName) forControlEvents:UIControlEventValueChanged];

    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";

    [self.addEmployer setEnabled:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    PFUser *currentUser = [PFUser currentUser];
    if (currentUser == nil) {
        [self performSegueWithIdentifier:@"logInSegue" sender:self];
    }
    [self.navigationController.navigationBar setHidden:NO];
      [self.addEmployer setEnabled:NO];
    [self retrieveEmployerName];
}

- (void)deleteCoreData {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
    [request setEntity:entity];
    NSSortDescriptor *tipDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalTips" ascending:NO];
    request.sortDescriptors = @[tipDescriptor];
    NSArray *deleteCD = [self.moc executeFetchRequest:request error:nil];
    for (Entry *deleteAll in deleteCD) {
        [self.moc deleteObject:deleteAll];
        NSLog(@"Deleted: %@", deleteAll);
        [self.employerTableView reloadData];
    }

}

- (void)retrieveEmployerName {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    if (user.objectId == nil) {
        [self performSegueWithIdentifier:@"logInSegue" sender:self];
    }else {
    [query whereKey:@"userId" equalTo:user.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.employerName = [NSMutableArray arrayWithObject:objects];
            [self.employerTableView reloadData];
        }else  {
            [self performSegueWithIdentifier:@"logInSegue" sender:self];
        }
            [self.refreshControl isRefreshing];
            [self.refreshControl endRefreshing];
        }];
    }
}

- (IBAction)logoutTapped:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logInSegue" sender:self];
}

//- (IBAction)addEmployerTapped:(UIBarButtonItem *)sender {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Employer" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"Employer";
//    }];
//    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        UITextField *employerName = [[alertController textFields] firstObject];
//        NSString *enteredEmployer = employerName.text;
//
//        PFObject *employerObject = [PFObject objectWithClassName:@"Employer"];
//
//        PFUser *user = [PFUser currentUser];
//        [employerObject setObject:enteredEmployer forKey:@"companyName"];
//        [user setObject:[employerObject objectForKey:@"companyName"] forKey:@"currentEmployer"];
//        [employerObject setObject:user.objectId forKey:@"userId"];
//
//        [employerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"Cannot save at this time");
//            }
//        }];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:addAction];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *currentEmployer = @"Current Employer";
    return currentEmployer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.employerName.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.backgroundColor = [UIColor blackColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    headerLabel.text = @"Current Employer";
    [headerView addSubview:headerLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employerCell"];

    PFUser *currentUser = [PFUser currentUser];
    cell.textLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [currentUser objectForKey:@"currentEmployer"];

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.employerName removeObjectAtIndex:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query whereKey:@"createdBy" equalTo:[[PFUser currentUser] objectId]];
    [query whereKeyExists:@"companyId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [PFObject deleteAllInBackground:objects];
            NSLog(@"Deleted: %@", objects);
        }
    }];
    for (PFObject *emp in self.employerName) {
        [emp delete];
        [emp saveInBackgroundWithBlock:nil];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Employer" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Employer";
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *employerName = [[alertController textFields] firstObject];
        NSString *enteredEmployer = employerName.text;

        PFObject *employerObject = [PFObject objectWithClassName:@"Employer"];

        PFUser *user = [PFUser currentUser];
        [employerObject setObject:enteredEmployer forKey:@"companyName"];
        [user setObject:[employerObject objectForKey:@"companyName"] forKey:@"currentEmployer"];
        [employerObject setObject:user.objectId forKey:@"userId"];

        [employerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Cannot save at this time");
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

    [self.addEmployer setEnabled:YES];
    [self deleteCoreData];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tipsSegue"]) {
        TipsTableViewController *tipsVC = segue.destinationViewController;
        [tipsVC.tipsTableView reloadData];
    }
    if ([segue.identifier isEqualToString:@"logInSegue"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
     if ([segue.identifier isEqualToString:@"signUpSegue"]) {
         SignUpViewController *svc;
         svc = segue.sourceViewController;
    }
    if ([segue.identifier isEqualToString:@"logInSegue"]) {
        LogInViewController *logIn;
        logIn = (LogInViewController *)segue.sourceViewController;
    }
 }


@end
