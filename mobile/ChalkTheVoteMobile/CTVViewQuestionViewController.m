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
#define VAL @"http://chalkthevote.com/Trial/iosValidateAnswer.php"


@interface CTVViewQuestionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionField;
@property (weak, nonatomic) IBOutlet UITableView *answerTable;
@property (strong, nonatomic) NSArray *answerArray;
@property NSTimer *timer;
@property BOOL emptyAnswerArray;
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
    if ([self.answerArray count] == 0) { self.emptyAnswerArray = YES; }
    else { self.emptyAnswerArray = NO;}
    [self.answerTable reloadData];
    NSLog(@"Refreshed Table");
}


- (IBAction)voteButtonPressed:(UIButton*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *aID = [NSString stringWithFormat:@"%ld",sender.tag];
    NSLog(@"Voting for:%ld", (long)aID);
    NSString *message = [NSString stringWithFormat:@"email=%@&aid=%@",username,aID];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VOTE];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        NSLog(@"Voted successful");
        [self viewWillAppear:YES];
    } else {
        //show error
    }
}

- (IBAction)validateButtonPressed:(UIButton*)sender {
    NSInteger aID = sender.tag;
    NSLog(@"Validating :%ld", (long)aID);
    NSString *message = [NSString stringWithFormat:@"qid=%ld&valid=1",(long)aID];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VAL];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        NSLog(@"Validate successful");
        [self reloadTable];
    } else {
        //show error
    }
}

- (IBAction)unvalidateButtonPressed:(UIButton*)sender {
    NSInteger aID = sender.tag;
    NSLog(@"Unvalidating:%ld", (long)aID);
    NSString *message = [NSString stringWithFormat:@"aid=%ld&valid=0",(long)aID];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VAL];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        NSLog(@"Unvalidated successful");
        [self reloadTable];
    } else {
        //show error
    }
}




- (void)moveImage:(UITableView *)image duration:(NSTimeInterval)duration
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"CTV_app_background_4.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.answerTable.delegate = self;
    self.answerTable.dataSource = self;
   /*
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    UIBarButtonItem *addAnswer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:nil];
    NSArray *actionButtonItems = @[shareItem,addAnswer];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    */
    
    UITableView *tableToMove = self.answerTable;
    
    tableToMove.frame = CGRectMake(10, 10, 200, 1000);
    [self.view addSubview:tableToMove];
    
    
    // Â
    // Move the image
    [self moveImage:tableToMove duration:0.4
              curve:UIViewAnimationCurveLinear x:0.0 y:-410.0];
    
}

-(void) viewWillAppear:(BOOL)animated {
    self.questionField.text = self.question;
    self.questionField.numberOfLines =0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                  target:self selector:@selector(reloadTable)
                                                userInfo:nil repeats:YES];
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
    if (self.emptyAnswerArray) { return 1; }
    return [self.answerArray count];
}



- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    self.answerTable.separatorColor = [UIColor clearColor]; //added
    //self.answerTable.backgroundView = [[UIImageView alloc] initWithImage:
      //                                 [UIImage imageNamed:@"CTV_app_background_4.png"]];
    self.answerTable.backgroundColor = [UIColor clearColor];
        

    if (!self.emptyAnswerArray) {
        if (self.moderatorMode) {
            //set cell background gradient image
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"cell_back3.png"];
            cell.backgroundView = av;
            NSString *string = [self.answerArray objectAtIndex:indexPath.row];
            NSArray *array = [string componentsSeparatedByString:@";"];
            NSString *qid = [array objectAtIndex:0];
            qid = [qid substringFromIndex:1];
            NSString *qtext = [array objectAtIndex:1];
            NSString *qVotes = [array objectAtIndex:2];
            NSInteger validated = [[array objectAtIndex:4] integerValue];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",qtext,qVotes];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            if (validated==0) {
                button.frame = CGRectMake(0, 0, 40, 40);
                [button addTarget:self action:@selector(validateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                UIImage *buttonImage = [UIImage imageNamed:@"ico1_off_clear.png"];
                [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
                [button setTag:[qid integerValue]];
                
            } else if (validated==1) {
                button.frame = CGRectMake(0, 0, 40, 40);
                [button addTarget:self action:@selector(unvalidateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        } else {
            //set cell background gradient image
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"cell_back3.png"];
            cell.backgroundView = av;
            NSString *string = [self.answerArray objectAtIndex:indexPath.row];
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
    }
    cell.backgroundColor  = [UIColor clearColor]; //added
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_back3_selected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
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