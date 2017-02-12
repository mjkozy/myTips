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


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UITextField *employerTextField;
@property (strong, nonatomic) NSMutableArray *userData;
@property (strong,nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;

//    self.ref = [[FIRDatabase database] reference];

    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;

    [self.navigationController.navigationBar setHidden:YES];

    [self.signUpButton.layer setBorderWidth:1.0];
    [self.signUpButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOffset:CGSizeMake(5,5)];
    [self.signUpButton.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOpacity:0.5];

    [self.spinner setHidesWhenStopped:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)onSignUpButtonTapped:(UIButton *)button {
    NSString *password = self.passwordTextField.text;
    NSString *employer = self.employerTextField.text;
    NSString *email = self.emailTextField.text;

    if ([email length] == 0 || [password length] == 0) {
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
        NSManagedObjectContext *context = self.moc;
        NSManagedObject *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        NSManagedObject *employerName = [NSEntityDescription insertNewObjectForEntityForName:@"Employer" inManagedObjectContext:context];
        [userInfo setValue:email forKey:@"firstname"];
        [userInfo setValue:password forKey:@"password"];
        [employerName setValue:employer forKey:@"employerName"];
        [employerName setValue:[userInfo valueForKey:@"firstname"] forKey:@"employee"];
        [userInfo setValue:[employerName valueForKey:@"employerName"] forKey:@"employers"];

        [context save:nil];
        NSLog(@"Employer: %@  User: %@  Passowrd: %@  EmployerName: %@", [userInfo valueForKey:@"employerName"], [userInfo valueForKey:@"firstname"], [userInfo valueForKey:@"password"], [employerName valueForKey:@"employerName"]);
//        [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//            if (user) {
//                [self setUserName:user];
//                [[[_ref child:@"Employer"]child:user.uid]setValue:@{@"currentEmployer" : employer}];
//
//            }
//            NSLog(@"%@  %@  %@", user.uid, user.email, employer);
//        }];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}

- (void)setUserName:(FIRUser *)user {
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    //user first part of email as username
    changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }

    }];
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
