//
//  CTVAddClassViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 3/19/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVAddClassViewController.h"
#define ENROLL @"http://www.chalkthevote.com/Trial/iosEnrollCourse.php"

@interface CTVAddClassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@end

@implementation CTVAddClassViewController

- (NSDictionary*) sendMessage:(NSString*)message toAddress:(NSString*)address {
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


- (IBAction)submitButtonPressed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *message = [NSString stringWithFormat:@"email=%@&key=%@",username,self.codeField.text];
    NSDictionary *enrollDictionary = [self sendMessage:message toAddress:ENROLL];
    if ([[enrollDictionary objectForKey:@"success"] integerValue]==1) {
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
    self.codeField.delegate = self;
    UIGraphicsBeginImageContext(self.view.frame.size);
    ;[[UIImage imageNamed:@"CTV_app_background_4.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //self.navigationController.navigationBar.hidden = YES;
    
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Add A Class";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
