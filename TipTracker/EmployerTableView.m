//
//  EmployerTableView.m
//  TipTracker
//
//  Created by Michael Kozy on 4/22/16.
//  Copyright © 2016 Michael Kozy. All rights reserved.
//


#import "TipsTableViewController.h"
#import "InputDataView.h"
#import "EmployerTableView.h"
#import "AppDelegate.h"
#import "KeychainWrapper.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"


@interface EmployerTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *employerTableView;
@property (strong, nonatomic) NSMutableArray *employerObjects;
@property (strong, nonatomic) NSArray *employerInfo;

@end

@implementation EmployerTableView



- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;


    [self isCurrentlyEmployed];

    UIImage *image = [UIImage imageNamed:@"appbackground.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";
    [self.addEmployer setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self retrieveEmployerName];
    PFUser *user = [PFUser currentUser];
    if (user == nil) {
        [self performSegueWithIdentifier:@"logInSegue" sender:self];
    }
}

- (void)retrieveEmployerName {
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
        [query whereKeyExists:@"totalTips"];
        [query whereKey:@"employee" equalTo:user];
        [query orderByAscending:@"date"];

        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                self.employerObjects = [[NSMutableArray alloc] initWithArray:objects];
                [self.employerTableView reloadData];
            }
        }];
    }
}

- (void)isCurrentlyEmployed {
    PFQuery *query = [PFQuery queryWithClassName:@"Employer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@, %@", error, [error userInfo]);
        }else {
            self.employerInfo = objects;
            NSLog(@"%@", objects);
        }
    }];
}

- (IBAction)logoutTapped:(id)sender {

    [PFUser logOut];
    [self performSegueWithIdentifier:@"logInSegue" sender:self];
}

- (IBAction)addEmployerTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Employer" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Employer";
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *employerName = [[alertController textFields]lastObject];
        NSString *enteredEmployer = employerName.text;

        PFObject *object = [PFObject objectWithClassName:@"Employer"];
        [object setObject:enteredEmployer forKey:@"employerName"];

        [object saveInBackgroundWithBlock:nil];


    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)loadEmployer {
//    NSManagedObjectContext *context = self.moc;
//    NSFetchRequest *request = [NSFetchRequest new];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Employer class]) inManagedObjectContext:context];
//    [request setEntity:entity];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"employerName" ascending:YES]];
//    NSArray *array = [context executeFetchRequest:request error:nil];
//    self.employerObjects = [NSMutableArray arrayWithArray:array];
//    if (!self.employerObjects.count) {
//        [self.addEmployer setEnabled:YES];
//    }
//        [self.addEmployer setEnabled:NO];
//
//     [self.employerTableView reloadData];
//}
//


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *currentEmployer = @"Current Employer";
    return currentEmployer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.employerObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employerCell"];

    PFObject *employer = [self.employerObjects objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:14];
    cell.textLabel.text = [employer objectForKey:@"employerName"];

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

//    NSManagedObjectContext *context = self.moc;

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete
        PFObject *deleteObject = [self.employerObjects objectAtIndex:indexPath.section];
        [deleteObject deleteInBackgroundWithBlock:nil];
        [deleteObject saveInBackgroundWithBlock:nil];
    }
    [self.addEmployer setEnabled:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tipsSegue"]) {
    UINavigationController *nav = segue.destinationViewController;
    TipsTableViewController *tvc;
    tvc = (TipsTableViewController *)nav.topViewController;
    NSIndexPath *indexPath = [self.employerTableView indexPathForCell:sender];
    tvc.employer = self.employerObjects[indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"logInSegue"]) {
        LogInViewController *lvc;
        lvc = segue.destinationViewController;
    }
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
     if ([segue.identifier isEqualToString:@"signUpSegue"]) {
         SignUpViewController *svc;
         svc = segue.sourceViewController;
    }
    if ([segue.identifier isEqualToString:@"logInSegue"]) {
        LogInViewController *logIn;
        logIn = segue.sourceViewController;
    }
 }


@end
