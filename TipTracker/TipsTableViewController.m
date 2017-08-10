//
//  TipsViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved.
//


#import "TipsTableViewController.h"

@interface TipsTableViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) NSArray *entryData;
@property (strong, nonatomic) NSArray *currentEmployerName;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEntryButton;

@property (strong, nonatomic) NSString *employerName;



@end

@implementation TipsTableViewController
@dynamic refreshControl;
 

- (void)viewDidLoad {
    [super viewDidLoad];
   //Get instance of App Delegate and Managed Object Context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

    [self.fetchedResultsController performFetch:nil];
    UIImage *mainBackGroundImage = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainBackGroundImage];
    self.tipsTableView.backgroundView = mainImageView;
    self.tipsTableView.backgroundColor = [UIColor grayColor];

    [self.navigationItem setTitle:@"Overview"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
}
//
//- (void)setCurrentEntry:(NSMutableArray *)entryData{
//    _entryData = entryData;
//    [self.tipsTableView reloadData];
//}

//- (void)loadData {
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entry" ];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
//    fetchRequest.sortDescriptors = @[sortDescriptor];
//    self.entryData = [self.moc executeFetchRequest:fetchRequest error:nil];
//    
//    if ([self.refreshControl isRefreshing]) {
//        [self.refreshControl endRefreshing];
//    }
//    [self.tipsTableView reloadData];
//}
//
//- (void)getEmployerName {
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employer"];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"employerName" ascending:YES];
//    fetchRequest.sortDescriptors = @[sortDescriptor];
//    self.entryData = [self.moc executeFetchRequest:fetchRequest error:nil];
//    
//}

- (IBAction)didTapAddEntryButton:(id)sender {
    
    [self addInfo];
}

#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
//    return 14;
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

//    CKRecord *requestRecords = [self.entryData objectAtIndex:indexPath.row];
    Entry *requestRecords = [self.fetchedResultsController objectAtIndexPath:indexPath];
            cell.dateLabel.text = [requestRecords valueForKey:@"createdAt"];
            cell.salesAmountLabel.text = [requestRecords valueForKey:@"totalSales"];
            cell.tipsAmountLabel.text = [requestRecords valueForKey:@"totalTips"];

    return cell;
}

#pragma mark TableView Delegate Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *deleteObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.moc deleteObject:deleteObject];
        [self.moc save:nil];
    }
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

#pragma mark Fetched Results Controller Delegate Methods


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    //Initialize Fetch Request
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
    //Sort Descriptors
    [fetch setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
    //Initialize fetched results controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    [fetch setFetchBatchSize:1];
    NSFetchedResultsController *fetchedResultsController1 = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = fetchedResultsController1;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tipsTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tipsTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tipsTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tipsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tipsTableView cellForRowAtIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tipsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tipsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}


#pragma mark helper methods

//- (void)fetchEntryData {
//
//    NSManagedObjectContext *context = self.moc;
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
//    [request setEntity:entity];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
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

//        // Store entry data to icloud
//        self.recievedRecord = [self.currentEmployerName objectAtIndex:0];

        // Create New Record
        NSManagedObjectContext *context = self.moc;
        NSEntityDescription *enteredInfo = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
        NSManagedObject *newEntry = [[NSManagedObject alloc] initWithEntity:enteredInfo insertIntoManagedObjectContext:context];
        
        Entry *employerEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
    
        //set values of new record
        [newEntry setValue:newSalesString forKey:@"totalSales"];
        [newEntry setValue:newTipsString forKey:@"totalTips"];
        [newEntry setValue:notesString forKey:@"notes"];
        [newEntry setValue:percentage forKey:@"percentEarned"];
        [newEntry setValue:stringFromDate forKey:@"createdAt"];
        [newEntry setValue:expensesString forKey:@"expenses"];
        [newEntry setValue:taxesString forKey:@"taxes"];
        [newEntry setValue:savingsString forKey:@"savings"];
        [newEntry setValue:spendingCashString forKey:@"spendingCash"];
        [employerEntry addEmployerObject:self.recievedRecord];
        
        //Save Managed Object Context
        [context save:nil];
    
        NSLog(@"%@", [newEntry valueForKey:@"employer"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark - Navigation
    //Pass created record to detail view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        Entry *sendRecord = [self.entryData objectAtIndex:indexPath.row];
        detailsVC.getRecord = sendRecord;
    
    }
}


@end
