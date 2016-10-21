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




@interface TipsTableViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
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

    UIImage *mainBackGroundImage = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainBackGroundImage];
    self.tipsTableView.backgroundView = mainImageView;
    self.tipsTableView.backgroundColor = [UIColor grayColor];

    [self.navigationItem setTitle:@"Overview"];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchEntryData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *user = [PFUser currentUser];
    if (user) {
    [self fetchEntryData];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.currentEmployerName = [NSArray arrayWithObject:objects];
        }
    }];
}

- (IBAction)didTapAddEntryButton:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Tips" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"enter sales";
                                 }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"enter tips";
        }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"enter notes";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"enter expense percent";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"enter taxes percent";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"enter savings percent";
    }];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *newSales = [[alertController textFields]firstObject];
        UITextField *newTips = [[alertController textFields] objectAtIndex:1];
        UITextField *notes = [[alertController textFields] objectAtIndex:2];
        UITextField *newExpenses = [[alertController textFields] objectAtIndex:3];
        UITextField *newTaxes = [[alertController textFields] objectAtIndex:4];
        UITextField *newSavings = [[alertController textFields] lastObject];

        float sales = [newSales.text floatValue];
        float tips =  [newTips.text floatValue];
        float expenses = [newExpenses.text floatValue];
        float taxes = [newTaxes.text floatValue];
        float savings = [newSavings.text floatValue];

        NSString *notesString = notes.text;
        NSString *newSalesString = [NSString stringWithFormat:@"$%.2f", sales];
        NSString *newTipsString = [NSString stringWithFormat:@"$%.2f", tips];

        float getExpenses = tips * expenses;
        float tipsAfterExpenses = tips - getExpenses;
        float getTaxes = tipsAfterExpenses * taxes;
        float tipsAfterTaxes = tipsAfterExpenses - getTaxes;
        float getSavings = tipsAfterTaxes * savings;
        float finalSpendingCash = tipsAfterTaxes - getSavings;


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

        PFUser *currentUser = [PFUser currentUser];
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        PFObject *employer = [self.currentEmployerName objectAtIndex:indexPath.row];
        PFObject *entryObject = [PFObject objectWithClassName:@"Entries"];
        [entryObject setObject:newSalesString forKey:@"totalSales"];
        [entryObject setObject:newTipsString forKey:@"totalTips"];
        [entryObject setObject:currentUser.objectId forKey:@"createdBy"];
        [entryObject setObject:employer.objectId forKey:@"companyId"];
        [entryObject setObject:notesString forKey:@"notes"];
        [entryObject setObject:percentage forKey:@"percentEarned"];
        [entryObject setObject:stringFromDate forKey:@"date"];
        [entryObject setObject:expensesString forKey:@"expenses"];
        [entryObject setObject:taxesString forKey:@"taxes"];
        [entryObject setObject:savingsString forKey:@"savings"];
        [entryObject setObject:spendingCashString forKey:@"spendingCash"];

        [entryObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [self fetchEntryData];
            }
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)fetchEntryData {
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"createdBy" equalTo:[[PFUser currentUser] objectId]];
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
    DescriptionCell *cell = (DescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];

    cell.backgroundColor = [UIColor clearColor];

    PFObject *entries = [self.entryObjects objectAtIndex:indexPath.row];
    cell.dateLabel.text = [entries objectForKey:@"date"];
    cell.tipsAmountLabel.text = [entries objectForKey:@"totalTips"];
    cell.salesAmountLabel.text = [entries objectForKey:@"totalSales"];
    cell.notesLabel.text = [entries objectForKey:@"notes"];
    cell.percentEarnedLabel.text = [entries objectForKey:@"percentEarned"];
    cell.billsLabel.text = [entries objectForKey:@"expenses"];
    cell.taxesLabel.text = [entries objectForKey:@"taxes"];
    cell.savingsLabel.text = [entries objectForKey:@"savings"];
    cell.spendingCashLabel.text = [entries objectForKey:@"spendingCash"];

        return cell;
}

#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.entryObjects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    PFObject *deleteObject = [self.entryObjects objectAtIndex:indexPath.row];
    [deleteObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [deleteObject saveInBackground];
    }];
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
