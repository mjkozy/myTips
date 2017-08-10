//
//  EmployerTableView.m
//  TipTracker
//
//  Created by Michael Kozy on 8/9/17.
//  Copyright © 2017 Michael Kozy. All rights reserved..
//



#import "EmployerTableView.h"



@interface EmployerTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *myEmployer;
@property (weak, nonatomic) IBOutlet UITableView *employerTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation EmployerTableView
@dynamic refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
 
    [self retrieveEmployerName];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(retrieveEmployerName) forControlEvents:UIControlEventValueChanged];

    UIImage *image = [UIImage imageNamed:@"viewImage.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
    self.employerTableView.backgroundView = backgroundImage;
    self.navigationItem.title = @"MyTips";

    [self.navigationController.navigationBar setHidden:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveEmployerName];
}

- (void)setCurrentEmployer:(NSMutableArray *)myEmployer {
    _myEmployer = myEmployer;
    [self.tableView reloadData];
}


- (IBAction)addEmployer:(id)sender {
    UIAlertController *addEmployer = [UIAlertController alertControllerWithTitle:@"Employer Name" message:@"Please enter your employer" preferredStyle:UIAlertControllerStyleAlert];
    
    [addEmployer addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"employer name";
    }];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *empName = [[addEmployer textFields]firstObject];
        
        NSString *emp = empName.text;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employer" inManagedObjectContext:self.moc];
        NSManagedObject *employer = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
        [employer setValue:emp forKey:@"employerName"];
        [self.moc save:nil];
        [self.addEmployer setEnabled:NO];
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [addEmployer addAction:okay];
    [self presentViewController:addEmployer animated:YES completion:nil];
}

- (void)retrieveEmployerName {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employer" ];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"employerName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    self.myEmployer = [self.moc executeFetchRequest:fetchRequest error:nil];
    
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    [self.tableView reloadData];
}

- (IBAction)logoutTapped:(id)sender {

    [self performSegueWithIdentifier:@"logInSegue" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *currentEmployer = @"My Current Employer";
    return currentEmployer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myEmployer.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 600, 25)];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Iowan Old Style Roman" size:20];
    headerLabel.text = @"Current Employer";
    [headerView addSubview:headerLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employerCell"];
    
    Employer *employer = [self.myEmployer objectAtIndex:indexPath.row];
//    NSManagedObject *employer = [self.myEmployer objectAtIndex:indexPath.row];
    cell.textLabel.text = [employer valueForKey:@"employerName"];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        NSManagedObject *deleteObject = [self.myEmployer objectAtIndex:indexPath.row];
        [self.moc deleteObject:deleteObject];
        [self.moc save:nil];
    }
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.addEmployer setEnabled:YES];
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tipsSegue"]) {
        TipsTableViewController *tipsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.employerTableView indexPathForSelectedRow];
        Employer *passedRecord = [self.myEmployer objectAtIndex:indexPath.row];
        tipsVC.empName = passedRecord.employerName;
      
    }
}




@end
