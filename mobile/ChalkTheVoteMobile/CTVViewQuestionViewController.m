//
//  CTVViewQuestionViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/2/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVViewQuestionViewController.h"
#import "CTVPostAnswerViewController.h"
#define VOTE @"http://chalkthevote.com/Trial/iosVoteAnswer.php"
#define REFRESH @"http://chalkthevote.com/Trial/iosGetAnswers.php"

@interface CTVViewQuestionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionField;
@property (weak, nonatomic) IBOutlet UITableView *answerTable;
@property (weak, nonatomic) NSArray *answerArray;
@end

@implementation CTVViewQuestionViewController

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

- (void) reloadTable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"email=%@&qid=%@",[defaults objectForKey:@"username"],self.qID];
    NSDictionary *answerDictionary = [self sendMessage:message toAddress:REFRESH];
    self.answerArray = [answerDictionary objectForKey:@"answerdetails"];
    NSLog(@"Answers Array: %@",self.answerArray);
    [self.answerTable reloadData];
    NSLog(@"Refreshed Table");
}


- (IBAction)voteButtonPressed:(UIButton*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSInteger aID = sender.tag;
    NSLog(@"Voting for:%ld", (long)aID);
    NSString *message = [NSString stringWithFormat:@"email=%@&qid=%ld",username,(long)aID];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VOTE];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        NSLog(@"Voted successful");
        [self viewWillAppear:YES];
    } else {
        //show error
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"CTV_app_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.answerTable.delegate = self;
    self.answerTable.dataSource = self;
}

-(void) viewWillAppear:(BOOL)animated {
    self.questionField.text = self.question;
    [self reloadTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"postAnswer"]) {
        CTVPostAnswerViewController *vc = [segue destinationViewController];
        vc.qid = self.qID;
    }
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.answerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *string = [self.answerArray objectAtIndex:indexPath.row];
    NSArray *array = [string componentsSeparatedByString:@";"];
    NSString *aid = [[array objectAtIndex:0] substringFromIndex:1];
    NSString *atext = [array objectAtIndex:1];
    NSString *aVotes = [array objectAtIndex:2];
    NSInteger voted = [[[array objectAtIndex:3] substringToIndex:2] integerValue];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",atext,aVotes];
    cell.textLabel.textColor = [UIColor whiteColor]; //added
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Hoefler Text" size:16.0f];
    self.answerTable.separatorColor = [UIColor clearColor]; //added
    self.answerTable.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"CTV_app_background_4.png"]];
    //set cell background gradient image
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"cell_back3.png"];
    cell.backgroundView = av;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (voted==0) {
        button.frame = CGRectMake(0, 0, 100, 40);
        [button setTitle:@"Vote" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(voteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:[aid integerValue]];
        
    } else if (voted==1) {
        button.frame = CGRectMake(0, 0, 100, 40);
        [button setTitle:@"Voted" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //button.frame = desiredLeft;
    [cell.contentView addSubview:button];
    [cell.contentView bringSubviewToFront:button];
    [cell addSubview:button];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [accessoryView setImage:[UIImage imageNamed:@"round_icon_flat_grey.png"]];
    [cell setAccessoryView:button];
    
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CTV_app_background.png"]]; //added
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CTV_app_background.png"]]; //added
    //self.tableView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor  = [UIColor clearColor]; //added
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



@end
