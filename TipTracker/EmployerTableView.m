//
//  EmployerTableView.m
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//



#import "EmployerTableView.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"



@interface EmployerTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *currentEmployer;
@property (weak, nonatomic) IBOutlet UITableView *employerTableView;
//@property (strong, nonatomic) NSFetchedResultsController *fetchController;


@end

@implementation EmployerTableView
@dynamic refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign into iCloud" message:@"Sign into iCloud to add customer data. On the home screen, launch settings, tap iCloud, and enter our Apple ID. Turn on iCloud Drive. If you do not have an iCloud account, tap Create a new Apple ID." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];

    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";
    

    [self.navigationController.navigationBar setHidden:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    CKDatabase *privateDB = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *pred = [NSPredicate predicateWithValue:TRUE];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Employer" predicate:pred];
    [privateDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
        }else {
            dispatch_async(dispatch_get_main_queue(),^{
                 self.currentEmployer = results;
                CKRecord *checkEmp = [self.currentEmployer objectAtIndex:0];
                if (checkEmp[@"employer"]) {
                    [self.addEmployer setEnabled:NO];
                }else{
                    [self.addEmployer setEnabled:YES];
                }
                [self.tableView reloadData];
            });
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}


- (IBAction)addEmployer:(id)sender {
    UIAlertController *addEmployer = [UIAlertController alertControllerWithTitle:@"Employer Name" message:@"Please enter your employer" preferredStyle:UIAlertControllerStyleAlert];
    
    [addEmployer addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"employer name";
    }];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *empName = [[addEmployer textFields]firstObject];
        
        NSString *emp = empName.text;
        CKRecordID *empID = [[CKRecordID alloc] initWithRecordName:@"currentEmployerName"];
        CKRecord *empRecord = [[CKRecord alloc] initWithRecordType:@"Employer" recordID:empID];
        empRecord[@"employer"] = emp;
        
        CKContainer *container = [CKContainer defaultContainer];
        CKDatabase *myDB = [container privateCloudDatabase];
        [myDB saveRecord:empRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                }else{
                    [self.tableView reloadData];
                }
            }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [addEmployer addAction:okay];
    [self presentViewController:addEmployer animated:YES completion:nil];
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

//- (void)deleteCoreData {
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
//    [request setEntity:entity];
//    NSSortDescriptor *tipDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalTips" ascending:NO];
//    request.sortDescriptors = @[tipDescriptor];
//    NSArray *deleteCD = [self.moc executeFetchRequest:request error:nil];
//    for (Entry *deleteAll in deleteCD) {
//        [self.moc deleteObject:deleteAll];
//        [self.employerTableView reloadData];
//    }
//}

//- (void)retrieveEmployerName {
//
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employer"];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:self.moc];
//    Employer *employer = [[Employer alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employerName = %@", employer.employerName];
//    [fetchRequest setPredicate:predicate];
//    self.currentEmployer = [self.moc executeFetchRequest:fetchRequest error:nil];
//    NSError *error = nil;
//    if (error) {
//        NSLog(@"Unable to fetch data %@", error.localizedDescription);
//    }
//
//
////    NSString *userID = [FIRAuth auth].currentUser.uid;
////    [[[_ref child:@"Employer"]child:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
////        self.employerName = snapshot.value;
////
////    }];
//}

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
    return self.currentEmployer.count;
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
    CKRecord *record = [self.currentEmployer objectAtIndex:indexPath.row];
    cell.textLabel.text = [record objectForKey:@"employer"];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertNotice = [UIAlertController alertControllerWithTitle:@"Unable to Delete in Beta Testing Mode" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [alertNotice addAction:okay];
        [self presentViewController:alertNotice animated:YES completion:nil];
    }
    [self.employerTableView reloadData];

}


//#pragma mark - Fetched Results Controller Delegate Methods
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.employerTableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert:
//            [self.employerTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeDelete:
//            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeMove:
//            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.employerTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeUpdate:
//            [self.employerTableView cellForRowAtIndexPath:indexPath];
//        default:
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.employerTableView endUpdates];
//}
//


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tipsSegue"]) {
        TipsTableViewController *tipsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.employerTableView indexPathForSelectedRow];
        CKRecord *passedRecord = [self.currentEmployer objectAtIndex:indexPath.row];
        tipsVC.recievedRecord = passedRecord;
        NSLog(@"%@", tipsVC.recievedRecord);
    }
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
//     if ([segue.identifier isEqualToString:@"signUpSegue"]) {
//         SignUpViewController *svc;
//         svc = segue.sourceViewController;
//    }
//    if ([segue.identifier isEqualToString:@"logInSegue"]) {
//        LogInViewController *logIn;
//        logIn = (LogInViewController *)segue.sourceViewController;
//    }
 }


@end
