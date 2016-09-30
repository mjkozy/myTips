//
//  SignUpViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/30/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "NavigationViewController.h"
#import "SignUpViewController.h"
#import "EmployerTableView.h"
#import "InputDataView.h"
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>



@interface SignUpViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UITextField *employerTextField;
@property (strong, nonatomic) NSMutableArray *userData;
@property (strong,nonatomic) NSManagedObjectContext *moc;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;


    self.firstNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;

    [self.navigationController.navigationBar setHidden:YES];

    [self.signUpButton.layer setBorderWidth:1.0];
    [self.signUpButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOffset:CGSizeMake(5,5)];
    [self.signUpButton.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOpacity:0.5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)onSignUpButtonTapped:(UIButton *)button {
    NSString *firstName = self.firstNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *employer = self.employerTextField.text;

    if ([firstName length] == 0 || [password length] == 0) {
            UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"Error"
                                                                            message:@"Please Complete All Fields"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
        PFUser *newUser = [PFUser user];
        PFObject *employerObject = [PFObject objectWithClassName:@"Employer"];
        newUser.username = firstName;
        newUser.password = password;
        newUser.email = email;
        [employerObject setObject:employer forKey:@"companyName"];

        [newUser setObject:[employerObject objectForKey:@"companyName"] forKey:@"currentEmployer"];

        NSLog(@"%@  %@  %@  %@", newUser.username, newUser.password, newUser.email, employerObject[@"companyName"]);

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"Error"
                                                                                message:[error.userInfo objectForKey:@"error"]
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {

                                                             }];
                [alert addAction:okay];
                [self presentViewController:alert animated:YES completion:nil];

            }else {
//                [self performSegueWithIdentifier:@"addInfoSegue" sender:self];
                [employerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        [newUser setObject:[employerObject objectForKey:@"companyName"] forKey:@"currentEmployer"];
                        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            [employerObject setObject:[[PFUser currentUser] objectId]forKey:@"userId"];
                            [employerObject saveInBackground];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }];
                    }
                }];
            }
        }];

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //set employer name and pass to input view for user entered details
    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
        InputDataView *input;
        input = segue.destinationViewController;
    }
}








@end
