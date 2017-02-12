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
#import "TipsTableViewController.h"



@interface TipsTableViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *entryObjects;
@property (strong, nonatomic) NSArray *entryData;
@property (strong, nonatomic) NSArray *currentEmployerName;
@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEntryButton;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSString *employerName;
@property (strong, nonatomic) NSDictionary *entriesDict;


@end

@implementation TipsTableViewController
@dynamic refreshControl;
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

//    self.firebaseDBRef = [[FIRDatabase database] reference];
    [self fetchEntryData];


//    NSString *userId = [FIRAuth auth].currentUser.uid;
//    [[[self.firebaseDBRef child:@"Employer"]child:userId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *employerName = snapshot.value;
//        self.employerName = employerName[@"currentEmployer"];
//    }];

    UIImage *mainBackGroundImage = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainBackGroundImage];
    self.tipsTableView.backgroundView = mainImageView;
    self.tipsTableView.backgroundColor = [UIColor grayColor];

    [self.navigationItem setTitle:@"Overview"];

//    [self getFirebaseData];
//    self.refreshControl = [UIRefreshControl new];
//    [self.refreshControl addTarget:self action:@selector(fetchEntryData) forControlEvents:UIControlEventValueChanged];

    [self.spinner setHidesWhenStopped:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    NSString *userId = [FIRAuth auth].currentUser.uid;
//    [[[self.firebaseDBRef child:@"Employer"]child:userId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *employerName = snapshot.value;
//        self.employerName = employerName[@"currentEmployer"];
//
//    }];

//    [self getFirebaseData];

}

- (IBAction)didTapAddEntryButton:(id)sender {

    [self addInfo];

}

#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if (self.entries.count >= 14) {
//        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"You have exceeded the ammount of entries allowed, please add 12 months for $4.99 or additional month for 1.99" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
//        [controller addAction:okAction];
//        [self presentViewController:controller animated:YES completion:nil];
//        [self.addEntryButton setEnabled:NO];
//    }else {
//        return self.entries.count;
//    }
    return self.entries.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor blackColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    NSString *userId = [FIRAuth auth].currentUser.uid;
    [[[self.firebaseDBRef child:@"Employer"]child:userId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *employerName = snapshot.value;
        self.employerName = employerName[@"currentEmployer"];
        headerLabel.text = self.employerName;
    }];

    [headerView addSubview:headerLabel];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DescriptionCell *cell = (DescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
    cell.backgroundColor = [UIColor clearColor];

//    CKRecord *requestRecords = [self.entries objectAtIndex:indexPath.row];

    NSManagedObjectContext *moc = self.moc;
    NSEntityDescription *requestRecords = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:moc];
            cell.dateLabel.text = [requestRecords valueForKey:@"createdAt"];
            cell.salesAmountLabel.text = [requestRecords valueForKey:@"totalSales"];
            cell.tipsAmountLabel.text = [requestRecords valueForKey:@"totalTips"];



//    PFObject *entry = [self.entries objectAtIndex:indexPath.row];

//    if (cell == nil) {
//        [self addInfo];
//    }

//    NSString *userID = [FIRAuth auth].currentUser.uid;
//    [[[[_firebaseDBRef child:@"entries"]childByAutoId]child:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *entry = snapshot.value;
//        cell.dateLabel.text = entry[@"date"];
//        cell.salesAmountLabel.text = entry[@"totalSales"];
//        cell.tipsAmountLabel.text = entry[@"totalTips"];
//    }];
    return cell;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.entries removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            PFObject *delObj = [self.entries objectAtIndex:indexPath.row];
            [delObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    [delObj saveInBackgroundWithBlock:nil];
                }
            }];
        }
    }];
    if (self.entries.count < 1) {
        [self addInfo];
    }

}

#pragma mark FetchedResultsController Delegate Methods

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
    [request setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"employers" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:31];

    NSFetchedResultsController *fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:@"Root1"];
    self.fetchedResultsController = fetchedResultsController1;
    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tipsTableView;

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Changed");
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tipsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tipsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Item Updated");
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"Item Moved");
            break;
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self.tipsTableView endUpdates];
}

#pragma mark helper methods

- (void)fetchEntryData {

    NSManagedObjectContext *context = self.moc;
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
    [request setEntity:entity];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"employers" ascending:YES]];
    self.entryData = [self.moc executeFetchRequest:request error:nil];
    [self.tipsTableView reloadData];
}

- (void)addInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Tips" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"total sales amount";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"total tips amount";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"percent as decimal for expenses";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"percent as decimal for taxes";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"percent as decimal for savings";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"enter notes";
    }];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *newSales = [[alertController textFields]firstObject];
        UITextField *newTips = [[alertController textFields] objectAtIndex:1];
        UITextField *newExpenses = [[alertController textFields] objectAtIndex:2];
        UITextField *newSavings = [[alertController textFields] objectAtIndex:3];
        UITextField *newTaxes = [[alertController textFields] objectAtIndex:4];
        UITextField *notes = [[alertController textFields] lastObject];
        // Convert strings to floats for calcutions to be done accurately
        float sales = [newSales.text floatValue];
        float tips =  [newTips.text floatValue];
        float expenses = [newExpenses.text floatValue];
        float taxes = [newTaxes.text floatValue];
        float savings = [newSavings.text floatValue];

        NSString *notesString = notes.text;
        NSString *newSalesString = [NSString stringWithFormat:@"$%.2f", sales];
        NSString *newTipsString = [NSString stringWithFormat:@"$%.2f", tips];

        // Calculations on float values
        float getExpenses = tips * expenses;
        float tipsAfterExpenses = tips - getExpenses;
        float getTaxes = tipsAfterExpenses * taxes;
        float tipsAfterTaxes = tipsAfterExpenses - getTaxes;
        float getSavings = tipsAfterTaxes * savings;
        float finalSpendingCash = tipsAfterTaxes - getSavings;

        // Convert floats back to strings for storing in Parse Server
        NSString *expensesString = [NSString stringWithFormat:@"$%.2f", getExpenses];
        NSString *taxesString = [NSString stringWithFormat:@"$%.2f", getTaxes];
        NSString *savingsString = [NSString stringWithFormat:@"$%.2f", getSavings];
        NSString *spendingCashString = [NSString stringWithFormat:@"$%.2f", finalSpendingCash];
        NSString *percentage = [NSString stringWithFormat:@"%.2f%%", tips/sales];
        NSDate *date = [NSDate date];
        NSDateFormatter *format = [NSDateFormatter new];
        format.locale = [NSLocale currentLocale];
        [format setDateFormat:@"MMM dd, yyyy"];
        NSString *stringFromDate = [format stringFromDate:date];

        // store entry data to core data
//        NSManagedObject *entryObject = [NSEntityDescription insertNewObjectForEntityForName:@"TipEntries" inManagedObjectContext:self.moc];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
        Entry *newEntry = [[Entry alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
//        PFObject *entryObject = [PFObject objectWithClassName:@"Entries"];
//        CKContainer *containerRef = [CKContainer defaultContainer];
//        CKDatabase *privateDB = [containerRef privateCloudDatabase];
//        CKRecordID *entryID = [[CKRecordID alloc] initWithRecordName:@"newEntry"];
//        CKRecord *newEntry = [[CKRecord alloc] initWithRecordType:@"TipsEntries" recordID:entryID];
        [newEntry setValue:self.employerName forKey:@"employers"];
        [newEntry setValue:newSalesString forKey:@"totalSales"];
        [newEntry setValue:newTipsString forKey:@"totalTips"];
        [newEntry setValue:notesString forKey:@"notes"];
        [newEntry setValue:percentage forKey:@"percentEarned"];
        [newEntry setValue:stringFromDate forKey:@"createdAt"];
        [newEntry setValue:expensesString forKey:@"expenses"];
        [newEntry setValue:taxesString forKey:@"taxes"];
        [newEntry setValue:savingsString forKey:@"savings"];
        [newEntry setValue:spendingCashString forKey:@"spendingCash"];
//        newEntry[@"companyId"] = self.employerName;
//        newEntry[@"totalSales"] = newSalesString;
//        newEntry[@"totalTips"] = newTipsString;
//        newEntry[@"notes"] = notesString;
//        newEntry[@"percentEarned"] = percentage;
//        newEntry[@"createdAt"] = stringFromDate;
//        newEntry[@"expenses"] = expensesString;
//        newEntry[@"taxes"] = taxesString;
//        newEntry[@"savings"] = savingsString;
//        newEntry[@"spendingCash"] = spendingCashString;
        [self.moc save:nil];

//        [privateDB saveRecord:newEntry completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//            if (!error) {
//                   NSLog(@"%@",record);
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot save entry data at this time, please try again later" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self dismissViewControllerAnimated:NO completion:nil];
//                    }];
//                    [controller addAction:okAction];
//                    [self presentViewController:controller animated:YES completion:nil];
//                });
//            }
//        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

    //        if (error) {
    //            NSLog(@"%@", error);
    //        }else {
    //
    //        }
    //    }];
    //
    //
    //
    ////        [entryObject setValue:self.employerName forKey:@"companyId"];
    ////        [entryObject setValue:newSalesString forKey:@"totalSales"];
    ////        [entryObject setValue:newTipsString forKey:@"totalTips"];
    ////        [entryObject setValue:notesString forKey:@"notes"];
    ////        [entryObject setValue:percentage forKey:@"percentEarned"];
    ////        [entryObject setValue:stringFromDate forKey:@"date"];
    ////        [entryObject setValue:expensesString forKey:@"expenses"];
    ////        [entryObject setValue:taxesString forKey:@"taxes"];
    ////        [entryObject setValue:savingsString forKey:@"savings"];
    ////        [entryObject setValue:spendingCashString forKey:@"spendingCash"];
    ////
    ////        [self.moc save:nil];
    ////        [entryObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
//        DetailViewController *detailsVC = segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
//        PFObject *detailObj = [self.entries objectAtIndex:indexPath.row];
//        UserData *userDataObject = [UserData new];
//        userDataObject.date = [detailObj objectForKey:@"date"];
//        userDataObject.spendingCash = [NSString stringWithFormat:@"Spending Cash:  %@",[detailObj objectForKey:@"spendingCash"] ];
//        userDataObject.sales = [detailObj objectForKey:@"totalSales"];
//        userDataObject.tips = [detailObj objectForKey:@"totalTips"];
//        userDataObject.percent = [detailObj objectForKey:@"percentEarned"];
//        userDataObject.expenses = [detailObj objectForKey:@"expenses"];
//        userDataObject.taxes = [detailObj objectForKey:@"taxes"];
//        userDataObject.savings = [detailObj objectForKey:@"savings"];
//        userDataObject.notes = [detailObj objectForKey:@"notes"];
//        detailsVC.userData = userDataObject;

    }
    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
        UINavigationController *inputNav = segue.destinationViewController;
        InputDataView *inputVC;
        inputVC = (InputDataView *)inputNav.topViewController;
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
