//
//  TipsViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/2/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "TipsTableViewController.h"

@interface TipsTableViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) NSArray *entryData;
@property (strong, nonatomic) NSArray *currentEmployerName;
@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEntryButton;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSString *employerName;



@end

@implementation TipsTableViewController
@dynamic refreshControl;
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    self.moc = appDelegate.managedObjectContext;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    [self getEmployerName];

    UIImage *mainBackGroundImage = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainBackGroundImage];
    self.tipsTableView.backgroundView = mainImageView;
    self.tipsTableView.backgroundColor = [UIColor grayColor];

    [self.navigationItem setTitle:@"Overview"];

    [self.spinner setHidesWhenStopped:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];

}
- (void)loadData {
    CKDatabase *myDB = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *pred = [NSPredicate predicateWithValue:TRUE];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"TipEntries" predicate:pred];
    
    [myDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.entryData = results;
                [self.tableView reloadData];
            });
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)getEmployerName {
    CKDatabase *empDB = [[CKContainer defaultContainer] privateCloudDatabase];
    NSPredicate *predicate = [NSPredicate predicateWithValue:TRUE];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Employer" predicate:predicate];
    
    [empDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentEmployerName = results;
            });
        }
    }];
}

- (IBAction)didTapAddEntryButton:(id)sender {
    
    [self addInfo];
}

#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.entryData.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor blackColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];

    [headerView addSubview:headerLabel];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DescriptionCell *cell = (DescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
    cell.backgroundColor = [UIColor clearColor];

    CKRecord *requestRecords = [self.entryData objectAtIndex:indexPath.row];

//    NSManagedObjectContext *moc = self.moc;
//    NSEntityDescription *requestRecords = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:moc];
            cell.dateLabel.text = [requestRecords objectForKey:@"dateEntered"];
            cell.salesAmountLabel.text = [requestRecords objectForKey:@"totalSales"];
            cell.tipsAmountLabel.text = [requestRecords objectForKey:@"totalTips"];

    return cell;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertNotice = [UIAlertController alertControllerWithTitle:@"Unable to Delete in Beta Testing Mode" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [alertNotice addAction:okay];
        [self presentViewController:alertNotice animated:YES completion:nil];
    }
    [self.tipsTableView reloadData];
}

//#pragma mark FetchedResultsController Delegate Methods
//
//- (NSFetchedResultsController *)fetchedResultsController {
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.moc];
//    [request setEntity:entity];
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"employers" ascending:YES];
//    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
//    [request setFetchBatchSize:31];
//
//    NSFetchedResultsController *fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:@"Root1"];
//    self.fetchedResultsController = fetchedResultsController1;
//    _fetchedResultsController.delegate = self;
//
//    return _fetchedResultsController;
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    UITableView *tableView = self.tipsTableView;
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeUpdate:
//            NSLog(@"Changed");
//            break;
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert:
//            [self.tipsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeDelete:
//            [self.tipsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        case NSFetchedResultsChangeUpdate:
//            NSLog(@"Item Updated");
//            break;
//        case NSFetchedResultsChangeMove:
//            NSLog(@"Item Moved");
//            break;
//    }
//
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//
//    [self.tipsTableView endUpdates];
//}
//
//#pragma mark helper methods
//
//- (void)fetchEntryData {
//
//    NSManagedObjectContext *context = self.moc;
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
//    [request setEntity:entity];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"employers" ascending:YES]];
//    self.entryData = [self.moc executeFetchRequest:request error:nil];
//    [self.tipsTableView reloadData];
//}

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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
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
        float getTaxes = tips * taxes;
        float tipsAfterTaxes = tipsAfterExpenses - getTaxes;
        float getSavings = tips * savings;
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

        // Store entry data to icloud
        self.recievedRecord = [self.currentEmployerName objectAtIndex:0];
        CKRecordID *entryID = [[CKRecordID alloc] initWithRecordName:newSalesString];
        CKRecordID *empID = [[CKRecordID alloc] initWithRecordName:[self.recievedRecord objectForKey:@"employer"]];
        CKRecord *newEntry = [[CKRecord alloc] initWithRecordType:@"TipEntries" recordID:entryID];
        CKRecord *newEmp = [[CKRecord alloc] initWithRecordType:@"Employer" recordID:empID];
        newEmp[@"entries"] = [[CKReference alloc] initWithRecord:newEntry action:CKReferenceActionNone];
        newEntry[@"currentEmployer"] = [[CKReference alloc] initWithRecord:newEmp action:CKReferenceActionNone];
        newEntry[@"empName"] = [self.recievedRecord objectForKey:@"employer"];
        newEntry[@"totalSales"] = newSalesString;
        newEntry[@"totalTips"] = newTipsString;
        newEntry[@"notes"] = notesString;
        newEntry[@"percentEarned"] = percentage;
        newEntry[@"dateEntered"] = stringFromDate;
        newEntry[@"expenses"] = expensesString;
        newEntry[@"taxes"] = taxesString;
        newEntry[@"savings"] = savingsString;
        newEntry[@"spendingCash"] = spendingCashString;

                CKContainer *container = [CKContainer defaultContainer];
                CKDatabase *privateDB = [container privateCloudDatabase];
                [privateDB saveRecord:newEntry completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    }else {
                        [privateDB saveRecord:newEntry completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                            NSLog(@"Employed by: %@, current entries saved are: %@", newEmp, newEntry);
                        }];
                    }
                }];
            [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        CKRecord *sendRecord = [self.entryData objectAtIndex:indexPath.row];
        detailsVC.getRecord = sendRecord;
    }
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
//    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
//        InputDataView *inputVC;
//          inputVC = segue.sourceViewController;
//    }
//if ([segue.identifier isEqualToString:@"signUpSegue"]) {
//        SignUpViewController *signUP;
//        signUP = segue.sourceViewController;
//    }
}


@end
