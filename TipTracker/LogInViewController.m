//
//  LogInViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/30/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "TipsTableViewController.h"
#import "SignUpViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>


@interface LogInViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *userData;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end


@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadEmployeeData) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar setHidden:YES];

    self.passwordTextField.delegate = self;
    [self.passwordTextField becomeFirstResponder];
    [self customButtons];
    PFUser *user = [PFUser currentUser];
    if (user) {
        [self.signUpButton setEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    PFObject *object;
    [self.firstName setText:[object objectForKey:@"firstname"]];
}

- (IBAction)onLogInButtonTapped:(UIButton *)button {
    NSString *firstName = self.firstName.text;
    NSString *password = self.passwordTextField.text;
    //Error Handling
    if ([firstName length] == 0 || [password length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid username and password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [alert addAction:okay];
    }
    else {
        [PFUser logInWithUsernameInBackground:firstName password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (error) {
                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Whoops" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                }];
                                                [alert addAction:cancel];
                                                [self presentViewController:alert animated:YES completion:nil];
                                            }else {
                                                PFUser *currentUser = [PFUser currentUser];
                                                if ([currentUser.objectId isKindOfClass:[@"Employer" class]]) {
                                                    [self.navigationController popViewControllerAnimated:NO];
                                                }
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }
                                    }];

    }
}

- (void)customButtons {
    [self.signUpButton.layer setBorderWidth:1.0];
    [self.signUpButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOffset:CGSizeMake(5,5)];
    [self.signUpButton.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOpacity:0.5];

    [self.logInButton.layer setBorderWidth:1.0];
    [self.logInButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.logInButton.layer setShadowOffset:CGSizeMake(5,5)];
    [self.logInButton.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [self.logInButton.layer setShadowOpacity:0.5];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)loadEmployeeData {

    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
        [query whereKey:@"firstname" equalTo:user];

        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                self.userData = objects;
            }
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }];
    }
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"signUpSegue"]) {
            SignUpViewController *signUp;
            signUp = segue.sourceViewController;
    }
}


@end
