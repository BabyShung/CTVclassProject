//
//  CTVLiveBoardTableViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/2/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVLiveBoardTableViewController.h"
#import "CTVViewQuestionViewController.h"
#import "CTVPostQuestionViewController.h"

#define REFRESH @"http://chalkthevote.com/Trial/iosQboardRefresh.php"
#define VOTE @"http://chalkthevote.com/Trial/iosVoteQuestion.php"
#define POSTQ @"http://chalkthevote.com/Trial/iosPushLiveQuestion.php"

@interface CTVLiveBoardTableViewController ()
@property NSTimer *timer;
@property BOOL emptyQuestionArray;
@end

@implementation CTVLiveBoardTableViewController

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
    //NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"responseData: %@", newStr);
    //NSLog(@"%@",err);
    //Parse to JSON
    NSError *error = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error != nil) {
        //NSLog(@"Error parsing JSON.");
    }
    else {
        //NSLog(@"Array: %@", jsonArray);
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

- (IBAction)postQuestion:(UIBarButtonItem *) sender{
        [self performSegueWithIdentifier:@"postQuestion" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *message = [NSString stringWithFormat:@"coursename=%@&email=%@",self.className,username];
    NSDictionary *questionDictionary = [self sendMessage:message toAddress:REFRESH];
    self.questionArray = [questionDictionary objectForKey:@"qdetails"];
    NSLog(@"%@",self.questionArray); */
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
  
    
    

    
    
    /*self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self selector:@selector(viewWillAppear:)
                                                    userInfo:nil repeats:YES]; */
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CTV_app_background.png"]]; //added
    //Sample courses
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.className;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                  target:self selector:@selector(reloadTable)
                                                userInfo:nil repeats:YES];
    [self reloadTable];
    
    
    
    NSUInteger arrayCount = [self.questionArray count];
    if (arrayCount==0 && !self.popUpShowed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The QBoard"
                                                        message:@"This is the QBoard. Nobody has posted a question yet. To get the discussion started click the plus button in the top right corner.."
                                                       delegate:nil
                                              cancelButtonTitle:@"Let's go!"
                                              otherButtonTitles:nil];
        [alert show];
        self.popUpShowed = YES;
    }
}

- (void) reloadTable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"email=%@&coursename=%@",[defaults objectForKey:@"username"],self.className];
    
    NSDictionary *questionsDictionary = [self sendMessage:message toAddress:REFRESH];
    self.questionArray = [NSMutableArray arrayWithArray:[questionsDictionary objectForKey:@"qdetails"]];
    if ([self.questionArray count] == 0) {self.emptyQuestionArray = YES;}
    else { self.emptyQuestionArray = NO; }
    [self.tableView reloadData];
    NSLog(@"Refreshed Table");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    if (self.emptyQuestionArray) { return; }
    NSString *string = [self.questionArray objectAtIndex:indexPath.row];
    NSArray *array = [string componentsSeparatedByString:@";"];
    NSString *qid = [array objectAtIndex:0];
    qid = [qid substringFromIndex:1];
    NSString *qtext = [array objectAtIndex:1];
    NSString *qVotes = [array objectAtIndex:2];
    self.question = qtext;
    self.qVotes = qVotes;
    self.qID = qid;
    [self performSegueWithIdentifier:@"viewQuestion" sender:self.view];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewQuestion"]) {
        CTVViewQuestionViewController *vc = [segue destinationViewController];
        vc.question = self.question;
        vc.qID = self.qID;
        vc.qVotes = self.qVotes;
    } else if ([[segue identifier] isEqualToString:@"postQuestion"]) {
        CTVPostQuestionViewController *vc = [segue destinationViewController];
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
    if (self.emptyQuestionArray) { return 1; }
    return [self.questionArray count];
}

//dynamic cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (IBAction)voteButtonPressed:(UIButton*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSInteger qID = sender.tag;
    NSLog(@"Voting for:%ld", (long)qID);
    NSString *message = [NSString stringWithFormat:@"email=%@&qid=%ld",username,(long)qID];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VOTE];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        NSLog(@"Voted successful");
        [self viewWillAppear:YES];
    } else {
        //show error
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.textColor = [UIColor whiteColor]; //added
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Hoefler Text" size:16.0f];
    self.tableView.separatorColor = [UIColor clearColor]; //added
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"CTV_app_background_4.png"]];
    /*
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
*/
    
  
    
   
    

    if (!self.emptyQuestionArray) {
        //set cell background gradient image
        UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
        av.backgroundColor = [UIColor clearColor];
        av.opaque = NO;
        av.image = [UIImage imageNamed:@"cell_back3.png"];
        cell.backgroundView = av;
        NSString *string = [self.questionArray objectAtIndex:indexPath.row];
        NSArray *array = [string componentsSeparatedByString:@";"];
        NSString *qid = [array objectAtIndex:0];
        qid = [qid substringFromIndex:1];
        NSString *qtext = [array objectAtIndex:1];
        NSString *qVotes = [array objectAtIndex:2];
        NSInteger voted = [[[array objectAtIndex:3] substringToIndex:2] integerValue];
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",qtext,qVotes];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
        if (voted==0) {
            button.frame = CGRectMake(0, 0, 40, 40);
            [button addTarget:self action:@selector(voteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *buttonImage = [UIImage imageNamed:@"ico1_off_clear.png"];
            [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
            [button setTag:[qid integerValue]];
        
        } else if (voted==1) {
            button.frame = CGRectMake(0, 0, 40, 40);
            UIImage *buttonImage2 = [UIImage imageNamed:@"ico1_off.png"];
            [button setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
        }
            //button.frame = desiredLeft;
            [cell.contentView addSubview:button];
            [cell.contentView bringSubviewToFront:button];
            [cell addSubview:button];
        
            UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [accessoryView setImage:[UIImage imageNamed:@"round_icon_flat_grey.png"]];
            [cell setAccessoryView:button];
    }

    cell.backgroundColor  = [UIColor clearColor]; //added
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_back3_selected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    return cell;
}


- (void)moveImage:(UITableViewCell *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //  Â
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    //Â
    // Commit the changes
    [UIView commitAnimations];
    // Â
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
