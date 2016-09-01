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
@property (weak, nonatomic) IBOutlet UITextField *enterEmployerTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIView *signUpView;
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
    self.enterEmployerTextField.delegate = self;

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
    NSString *employerName = self.enterEmployerTextField.text;

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
    else {

        [PFUser currentUser];
        PFUser *newUser = [PFUser user];
        [newUser setObject:firstName forKey:@"firstname"];
        [newUser setObject:password forKey:@"password"];
        [newUser setObject:employerName forKey:@"employerName"];

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
                [self performSegueWithIdentifier:@"addInfoSegue" sender:self];
//                    [self.navigationController popViewControllerAnimated:YES];
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
        UINavigationController *inputNav = segue.destinationViewController;
        InputDataView *input;
        input = (InputDataView *)inputNav.topViewController;
    }
}








@end
