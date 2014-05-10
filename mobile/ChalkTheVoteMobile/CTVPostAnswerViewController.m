//
//  CTVPostAnswerViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/23/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVPostAnswerViewController.h"
#define POST @"http://chalkthevote.com/Trial/iosPushAnswer.php"

@interface CTVPostAnswerViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textBox;
@property (weak, nonatomic) IBOutlet UILabel *errorField;

@end

@implementation CTVPostAnswerViewController

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


- (IBAction)submitButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults valueForKey:@"username"];
    NSString *message = [NSString stringWithFormat:@"email=%@&qid=%@&atext=%@",username,self.qid,self.textBox.text];
    NSLog(@"Posting answer: %@",message);
    NSDictionary *postDicionary = [self sendMessage:message toAddress:POST];
    if ([[postDicionary objectForKey:@"success"] integerValue]==1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.errorField.text = @"Error. Try again.";
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
    self.textBox.delegate = self;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"CTV_app_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.textBox becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Post an Answer";
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

- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    return YES;
}


- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    return YES;
}

@end
