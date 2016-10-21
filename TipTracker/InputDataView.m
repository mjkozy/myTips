//
//  InputTableViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/1/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import "TipsTableViewController.h"
#import "InputDataView.h"



@interface InputDataView ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *inputTableView;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *totalSalesTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalTipsTextField;
@property (strong, nonatomic) NSMutableArray *allData;
@property (strong, nonatomic) NSArray *userData;
@property (strong, nonatomic) NSArray *employerData;
@property (strong, nonatomic) NSArray *entryData;
@property (strong, nonatomic) NSManagedObjectContext *moc;


@end

@implementation InputDataView

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

    self.totalTipsTextField.delegate = self;
    self.totalSalesTextField.delegate = self;
    
    [self textFieldBorders];
    [self queryParse];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryParse];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTapped:(id)sender {
    NSString *sales = self.totalSalesTextField.text;
    NSString *tips = self.totalTipsTextField.text;
    if (sales == 0 || tips == 0){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid amount with the format 00.00" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [error addAction:okay];
            [self presentViewController:error animated:YES completion:nil];
    }else {
            [self saveData];
        }
}

- (void)queryParse {

    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query whereKey:@"userId" equalTo:currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.employerData = objects;
            NSLog(@"%@", self.employerData);
        }
    }];
}

#pragma mark - Helper Methods

- (void)textFieldBorders {
    self.totalSalesTextField.delegate = self;
    self.totalTipsTextField.delegate = self;
    //configure textfields
    self.totalSalesTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.totalSalesTextField.layer.borderWidth = 1.0;

    self.totalTipsTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.totalTipsTextField.layer.borderWidth = 1.0;

    self.notesTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.notesTextField.layer.borderWidth = 2.0;
    self.notesTextField.font = [UIFont fontWithName:@"Helvetica Neue" size:15];

    self.tableView.sectionHeaderHeight = 20;

    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)dismissModalView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveAndDismissModalView {
    [self saveData];
    [self dismissModalView];
}

- (void)closeAndSave {
    if ([self.totalSalesTextField.text length] == 0 || [self.totalTipsTextField.text length] == 0) {
        UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid amount with the format 0.00" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [error addAction:okay];
        [self presentViewController:error animated:YES completion:nil];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)saveData {

    float tipsEarned = [self.totalTipsTextField.text floatValue];
    float dailyRing = [self.totalSalesTextField.text floatValue];

    NSString *notes = self.notesTextField.text;
    NSString *percentEarned = [NSString stringWithFormat:@"%.2f%% ", tipsEarned / dailyRing];
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [NSDateFormatter new];
    format.locale = [NSLocale currentLocale];
    [format setDateFormat:@"MMM dd, yyyy"];

    NSString *stringFromDate = [format stringFromDate:date];
    NSString *tipsString = [NSString stringWithFormat:@"$%.2f", tipsEarned];
    NSString *salesString = [NSString stringWithFormat:@"$%.2f", dailyRing];

    NSIndexPath *indexPath = [self.inputTableView indexPathForSelectedRow];
    PFObject *employerObject = [self.employerData objectAtIndex:indexPath.row];
    PFObject *newEntry = [PFObject objectWithClassName:@"Entries"];

    PFUser *currentUser = [PFUser currentUser];
    [newEntry setObject:tipsString forKey:@"totalTips"];
    [newEntry setObject:salesString forKey:@"totalSales"];
    [newEntry setObject:stringFromDate forKey:@"date"];
    [newEntry setObject:percentEarned forKey:@"percentEarned"];
    [newEntry setObject:notes forKey:@"notes"];
    [newEntry setObject:employerObject.objectId forKey:@"companyId"];
    [newEntry setObject:currentUser.objectId forKey:@"createdBy"];

    [newEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog( @"%@ %@", error, [error userInfo]);
        }
    }];

    Entry *tips = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.moc];
    tips.totalTips = [NSNumber numberWithFloat:tipsEarned];
    [self.moc save:nil];

    NSLog(@"%@ is currently employed by %@",[NSString stringWithFormat:@"%@",[employerObject valueForKey:@"userId"]], employerObject[@"companyName"]);

    [self performSegueWithIdentifier:@"unwindToMain" sender:self];
}

- (void)clearFields {
    self.totalSalesTextField.text = @"";
    self.totalTipsTextField.text = @"";
    self.notesTextField.text = @"";
}

#pragma mark TEXTFIELD DELEGATE METHODS

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    //Check that only numberic values are being entered
    NSCharacterSet *numberCheck = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![numberCheck characterIsMember:c]) {
            return NO;
        }
    }
    //Limit numeric entries
    NSUInteger limitCharactersEntered = textField.text.length - range.length + string.length;
    if (limitCharactersEntered > 7) {
        return NO;
    }
    return YES;
}

- (BOOL)checkCharacters:(NSRange)range replaceString:(NSString *)string textField:(UITextField *)totalTipsTextField {
    //Limit characters entered
    NSUInteger checkValueLength = totalTipsTextField.text.length - range.length + string.length;
    if (checkValueLength > 7) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

- (void)unwindToMain:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"unwindToMain"]) {
        TipsTableViewController *tvc;
        tvc = segue.destinationViewController;
//        [main.tipsTableView reloadData];
    }
}


@end
