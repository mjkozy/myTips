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

    [self.spinner setHidesWhenStopped:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *user = [PFUser currentUser];
    if (user) {
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.currentEmployerName = [NSArray arrayWithObject:objects];
        }else {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"You have exceeded the ammount of entries allowed, please add 12 months for $4.99 or additional month for 1.99" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:okAction];
            [self presentViewController:controller animated:YES completion:nil];
        }
        }];
    }
    [self fetchEntryData];
}

- (IBAction)didTapAddEntryButton:(id)sender {

    [self addInfo];

}
// Query Parse Server
- (void)fetchEntryData {
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query whereKey:@"createdBy" equalTo:[[PFUser currentUser] objectId]];
    // Parse Server Cache Policy first load cached results then query Parse Server
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    // Ascending order by date created
    [query orderByAscending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.entryData = objects;
            self.entryObjects = [[NSMutableArray alloc] initWithArray:objects];
            [self.tipsTableView reloadData];
        }else {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot retrieve data at this time, please try again later" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:okAction];
            [self presentViewController:controller animated:YES completion:nil];
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.entryObjects.count >= 14) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"You have exceeded the ammount of entries allowed, please add 12 months for $4.99 or additional month for 1.99" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:okAction];
        [self presentViewController:controller animated:YES completion:nil];
        [self.addEntryButton setEnabled:NO];
    }else {
        return self.entryObjects.count;
    }
    return 14;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    PFUser *currentUser = [PFUser currentUser];
    return [currentUser objectForKey:@"currentEmployer"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor blackColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    PFUser *currentUser = [PFUser currentUser];;
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
    cell.expensesLabel.text = [entries objectForKey:@"expenses"];
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
        PFObject *delObj = [self.entryObjects objectAtIndex:indexPath.row];
        [delObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [delObj saveInBackgroundWithBlock:nil];
            }
        }];
    if (self.entryObjects.count == 0) {
        [self addInfo];
    }
}
#pragma mark helper methods


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
        textField.placeholder = @"percentage for expenses";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"percentage to save";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"percentage for taxes";
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

        NSLog(@"%@, %@", savingsString, notes);

        [entryObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [self fetchEntryData];
            }
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tipsTableView indexPathForSelectedRow];
        PFObject *detailObj = [self.entryObjects objectAtIndex:indexPath.row];
        UserData *userDataObject = [UserData new];
        userDataObject.date = [detailObj objectForKey:@"date"];
        userDataObject.spendingCash = [NSString stringWithFormat:@"Spending Cash:  %@",[detailObj objectForKey:@"spendingCash"] ];
        userDataObject.sales = [detailObj objectForKey:@"totalSales"];
        userDataObject.tips = [detailObj objectForKey:@"totalTips"];
        userDataObject.percent = [detailObj objectForKey:@"percentEarned"];
        userDataObject.expenses = [detailObj objectForKey:@"expenses"];
        userDataObject.taxes = [detailObj objectForKey:@"taxes"];
        userDataObject.savings = [detailObj objectForKey:@"savings"];
        userDataObject.notes = [detailObj objectForKey:@"notes"];
        detailsVC.userData = userDataObject;

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
