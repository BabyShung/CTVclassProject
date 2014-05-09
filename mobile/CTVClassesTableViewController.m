//
//  CTVClassesTableViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 3/19/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVClassesTableViewController.h"
#import "CTVLiveBoardTableViewController.h"

#define COURSELIST @"http://chalkthevote.com/Trial/iosCourseList.php"
#define MODLIST @"http://chalkthevote.com/Trial/iosModeratorCourseList.php"


@interface CTVClassesTableViewController ()
@property (nonatomic,strong) NSString *className;
@property BOOL emptyClassArray;
@end

@implementation CTVClassesTableViewController

- (NSDictionary*) sendMessage:(NSString*)message toAddress:(NSString*)address {
    //TODO verify URL and add back in password
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:address];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseData: %@", newStr);
    NSLog(@"%@",err);
    //Parse to JSON
    NSError *error = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        NSLog(@"Array: %@", jsonArray);
    }
    return jsonArray;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)addCourseButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addCourse" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //prettify
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    //Sample courses
    //self.classesArray = [NSArray arrayWithObjects:@"iOS Programming", @"Networks", @"Programming Language Concepts", @"Fundamentals of Software Engineering", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Classes";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"email=%@",[defaults objectForKey:@"username"]];
    NSDictionary *coursesDictionary = [self sendMessage:message toAddress:COURSELIST];
    NSDictionary *moderatorDictionary = [self sendMessage:message toAddress:MODLIST];
    self.classesArray = [NSMutableArray arrayWithArray:[moderatorDictionary objectForKey:@"courselist"]];
    [self.classesArray addObjectsFromArray:[coursesDictionary objectForKey:@"courselist"]];
    NSUInteger arrayCount = [self.classesArray count];
    if (arrayCount==0 && !self.popUpShowed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!"
                                                        message:@"This is your classes page. Since you don't have any classes yet it is empty. To add a class, click the plus button in the top right corner."
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it"
                                              otherButtonTitles:nil];
        [alert show];
        self.popUpShowed = YES;
        
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.className = [self.classesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"viewClass" sender:self.view];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewClass"]) {
        CTVLiveBoardTableViewController *vc = [segue destinationViewController];
        vc.className = self.className;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.classesArray count] == 0) {
        self.emptyClassArray = YES;
        return 1;
    }
    self.emptyClassArray = NO;
    return [self.classesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    self.tableView.separatorColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor]; //added
    cell.textLabel.font = [UIFont fontWithName:@"Hoefler Text" size:25.0f];
    self.tableView.separatorColor = [UIColor clearColor]; //added
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"CTV_class_selection.png"]];
    cell.backgroundColor  = [UIColor clearColor]; //added
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_back3_selected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    if (!self.emptyClassArray) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.classesArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
