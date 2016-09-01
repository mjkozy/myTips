//
//  SignUpViewController.m
//  TipTracker
//
//  Created by Michael Kozy on 3/30/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//

#import "NavigationViewController.h"
#import "SignUpViewController.h"
#import "EditEmployerView.h"
#import "InputDataView.h"
#import "Employee.h"
#import "Employer.h"
#import <Parse/Parse.h>






@interface SignUpViewController ()<UITextFieldDelegate>
@property (strong,nonatomic)NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterEmployerTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UIView *signUpView;
@property (strong, nonatomic) NSMutableArray *userData;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    // Do any additional setup after loading the view.

    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.enterEmployerTextField.delegate = self;

    NSLog(@"%@", [self documentDirectory]);
    [self userExists];

    [self.signUpButton.layer setBorderWidth:1.0];
    [self.signUpButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOffset:CGSizeMake(5,5)];
    [self.signUpButton.layer setShadowColor:[[UIColor blackColor]CGColor]];
    [self.signUpButton.layer setShadowOpacity:0.5];

    UISwipeGestureRecognizer *swipeToClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [swipeToClose setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:swipeToClose];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self userExists];
}


- (void)close {
    
    [self performSegueWithIdentifier:@"logInSegue" sender:self];
    [self.animator removeAllBehaviors];
}

- (IBAction)onSignUpButtonTapped:(id)sender {

    [self userInfoSavedCoreData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return NO;
}

- (void)userInfoSavedCoreData {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *employerName = self.enterEmployerTextField.text;

    if (username && password) {

        Employee *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.moc];
        Employer *employerObject = [NSEntityDescription insertNewObjectForEntityForName:@"Employer" inManagedObjectContext:self.moc];
        Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.moc];
        [userInfo addEntriesObject:entry];
        [userInfo addCurrentEmployerObject:employerObject];
        employerObject.name = employerName;
        userInfo.username = username;
        userInfo.password = password;
        [self saveDefaults];
        [self save];
        [self.moc save:nil];

    }
    [self performSegueWithIdentifier:@"addInfoSegue" sender:self];
}

- (void)userExists {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user boolForKey:@"userExists"] == YES && [user boolForKey:@"isCurrentlyEmployed"] == YES) {
        [self.tabBarController setSelectedIndex:0];
    }else
        NSLog(@"Enter Info");
}

- (void)saveDefaults {
    Employee *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.moc];
    Employer *employerObject = [NSEntityDescription insertNewObjectForEntityForName:@"Employer" inManagedObjectContext:self.moc];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userInfo.username forKey:@"username"];
    [user setObject:userInfo.password forKey:@"password"];
    [user setObject:employerObject.name forKey:@"currentEmployer"];
    if ([user valueForKey:@"username"] && [user valueForKey:@"password"]) {
        [user setBool:YES forKey:@"userExists"];
        [user synchronize];
    }else {
        [user setBool:NO forKey:@"userExists"];
        [user synchronize];
    }if ([[user valueForKey:@"currentEmployer"] isEmpty]) {
        [user setBool:NO forKey:@"isCurrentEmployer"];
        [user synchronize];
    }else {
        [user setBool:YES forKey:@"isCurrentEmployer"];
        [user synchronize];
    }
    [user synchronize];
}

- (NSURL *)plist {
    return [[self documentDirectory] URLByAppendingPathComponent:@"userData.plist"];
}

- (NSURL *)documentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (void)load {
    NSURL *plist = [[self documentDirectory] URLByAppendingPathComponent:@"userData.plist"];
    self.userData = [NSMutableArray arrayWithContentsOfURL:plist] ?: [NSMutableArray new];
}

- (void)save {
    NSURL *plist = [[self documentDirectory] URLByAppendingPathComponent:@"userData.plist"];
    [self.userData writeToURL:plist atomically:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//    set employer name and pass to input view for user entered details
    if ([segue.identifier isEqualToString:@"addInfoSegue"]) {
        UINavigationController *inputNav = segue.destinationViewController;
        InputDataView *input = (InputDataView *)inputNav.topViewController;
        
        input.employer = self.employer;
    }
}








@end
