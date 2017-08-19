//
//  EmployerViewController.m
//  myTips
//
//  Created by Michael Kozy on 8/10/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//

#import "EmployerViewController.h"


@interface EmployerViewController ()

@property (strong, nonatomic) NSString *empName;


@end

@implementation EmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Error" message:@"Please Sign into iCloud to add customer data. On the home screen, launch settings, tap iCloud, and enter our Apple ID. Turn on iCloud Drive. If you do not have an iCloud account, tap Create a new Apple ID." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okay];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    //Perform fetch
    [self.fetchedResultsController performFetch:&error];


    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";
    
    
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Error" message:@"Please Sign into iCloud to add customer data. On the home screen, launch settings, tap iCloud, and enter our Apple ID. Turn on iCloud Drive. If you do not have an iCloud account, tap Create a new Apple ID." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:okay];
            [self presentViewController:alert animated:YES completion:nil];
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
        NSManagedObjectContext *context = self.moc;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:context];
        Employer *employer = [[Employer alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

        [employer setValue:emp forKey:@"employerName"];
        [self.moc save:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [addEmployer addAction:okay];
    [self presentViewController:addEmployer animated:YES completion:nil];
}

- (IBAction)logoutTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"logInSegue" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *currentEmployer = @"My Current Employer";
    return currentEmployer;
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


#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employerCell"];
    
    Employer *employer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [employer valueForKey:@"employerName"];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Alert user that all data will be deleted prior to deletion
        UIAlertController *confirmDelete = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Deleting employer will delete all associated data, are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *imSure = [UIAlertAction actionWithTitle:@"I'm Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
            NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
            NSError *error = nil;
            [self.moc executeRequest:delete error:&error];
            NSManagedObject *deleteObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.moc deleteObject:deleteObject];
            [self.moc save:nil];
            [self.addEmployer setEnabled:YES];
        }];
        UIAlertAction *imNotSure = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [confirmDelete addAction:imSure];
        [confirmDelete addAction:imNotSure];
        [self presentViewController:confirmDelete animated:YES completion:nil];
    }
   
    [self.employerTableView reloadData];
}

#pragma mark Fetched Results Controller Delegate Methods


- (NSFetchedResultsController *)fetchedResultsController {
    
    NSManagedObjectContext *context = self.moc;
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
        //Initialize Fetch Request
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Employer"];
        //Sort Descriptors
        [fetch setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"employerName" ascending:NO]]];
        //Initialize fetched results controller
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSFetchedResultsController *fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = fetchedResultsController1;
    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.employerTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.employerTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.employerTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.employerTableView cellForRowAtIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.employerTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.employerTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tipsSegue"]) {
        TipsTableViewController *tipsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.employerTableView indexPathForSelectedRow];
        Employer *passedRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
        tipsVC.recievedRecord = passedRecord;
        tipsVC.empName = [passedRecord valueForKey:@"employerName"];
    }
}

@end
