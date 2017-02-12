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
#import "LogInViewController.h"
#import "SignUpViewController.h"



@interface EmployerTableView ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *employerName;
@property (strong, nonatomic) NSArray *currentEmployer;
@property (strong, nonatomic) FIRDatabaseReference *empReference;
@property (weak, nonatomic) IBOutlet UITableView *employerTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (weak, nonatomic) IBOutlet UILabel *employerCell;


@end

@implementation EmployerTableView
@dynamic refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

//    self.refreshControl = [UIRefreshControl new];
//    [self.refreshControl addTarget:self action:@selector(retrieveEmployerName) forControlEvents:UIControlEventValueChanged];

//    self.ref = [[FIRDatabase database] reference];

    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";
    [self retrieveEmployerName];

    [self.addEmployer setEnabled:NO];
    [self.navigationController.navigationBar setHidden:NO];

//    FIRUser *user = [FIRAuth auth].currentUser;
//    if (user) {
////        [self performSegueWithIdentifier:@"logInSegue" sender:self];
//    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveEmployerName];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
////    FIRUser *user = [FIRAuth auth].currentUser;
////    if (user) {
//////        [self performSegueWithIdentifier:@"logInSegue" sender:self];
////    }
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.addEmployer setEnabled:NO];
//
////    [self retrieveEmployerName];
////    PFUser *currentUser = [PFUser currentUser];
////    if (currentUser == nil) {
////        [self performSegueWithIdentifier:@"logInSegue" sender:self];
////    }
////    [self.navigationController.navigationBar setHidden:NO];
////      [self.addEmployer setEnabled:NO];
////    [self retrieveEmployerName];
//}

- (void)deleteCoreData {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
    [request setEntity:entity];
    NSSortDescriptor *tipDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalTips" ascending:NO];
    request.sortDescriptors = @[tipDescriptor];
    NSArray *deleteCD = [self.moc executeFetchRequest:request error:nil];
    for (Entry *deleteAll in deleteCD) {
        [self.moc deleteObject:deleteAll];
        [self.employerTableView reloadData];
    }
}

- (void)retrieveEmployerName {

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employer"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:self.moc];
    Employer *employer = [[Employer alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employerName = %@", employer.employerName];
    [fetchRequest setPredicate:predicate];
    self.currentEmployer = [self.moc executeFetchRequest:fetchRequest error:nil];
    NSError *error = nil;
    if (error) {
        NSLog(@"Unable to fetch data %@", error.localizedDescription);
    }


//    NSString *userID = [FIRAuth auth].currentUser.uid;
//    [[[_ref child:@"Employer"]child:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        self.employerName = snapshot.value;
//
//    }];
}

- (IBAction)logoutTapped:(id)sender {

//    FIRAuth *fbAuth = [FIRAuth auth];
//    NSError *signOutError;
//    BOOL status = [fbAuth signOut:&signOutError];
//    if (!status) {
//        NSLog(@"Error signing out: %@", signOutError);
//        return;
//    }
    [self performSegueWithIdentifier:@"logInSegue" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *currentEmployer = @"My Current Employer";
    return currentEmployer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    headerLabel.text = @"Current Employer";
    [headerView addSubview:headerLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employerCell"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:self.moc];
    Employer *empName = [[Employer alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
    empName = [self.currentEmployer objectAtIndex:indexPath.row];
    cell.textLabel.text = empName.employerName;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.employerName removeObjectAtIndex:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    PFObject *empNameObj = [PFObject objectWithClassName:@"Employer"];
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query whereKey:@"companyId" equalTo:empNameObj.objectId];
    [query whereKeyExists:@"companyId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [PFObject deleteAllInBackground:objects];
        }if (error) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot retrieve data at this time, please try again later" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:okAction];
        [self presentViewController:controller animated:YES completion:nil];
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
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot retrieve data at this time, please try again later" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
                [controller addAction:okAction];
                [self presentViewController:controller animated:YES completion:nil];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

    [self.addEmployer setEnabled:YES];
//    [self deleteCoreData];

}


#pragma mark - Fetched Results Controller Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.employerTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.employerTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.employerTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.employerTableView cellForRowAtIndexPath:indexPath];
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.employerTableView endUpdates];
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
