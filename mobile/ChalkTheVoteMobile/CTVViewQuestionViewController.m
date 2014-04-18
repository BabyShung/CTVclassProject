//
//  CTVViewQuestionViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/2/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVViewQuestionViewController.h"
#define VOTE @"http://chalkthevote.com/Trial/iosVoteQuestion.php"

@interface CTVViewQuestionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionField;

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


- (IBAction)voteButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSLog(@"%@",self.qid);
    NSString *message = [NSString stringWithFormat:@"email=%@&qid=%@",username,self.qid];
    NSDictionary *voteDictionary = [self sendMessage:message toAddress:VOTE];
    if ([[voteDictionary objectForKey:@"success"] integerValue]==1) {
        [self.navigationController popViewControllerAnimated:YES];
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
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    self.questionField.text = self.question;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
