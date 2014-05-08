//
//  CTVCreateClassViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 5/7/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVCreateClassViewController.h"
#define REG @"http://chalkthevote.com/Trial/iosRegisterCourse.php"

@interface CTVCreateClassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *courseNameField;
@property (weak, nonatomic) IBOutlet UITextField *numStudentsField;

@end

@implementation CTVCreateClassViewController

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
    self.courseNameField.delegate = self;
    self.numStudentsField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createButtonPressed {
    
    if ( ([self.courseNameField.text length] > 0) && ([self.numStudentsField.text length] > 0)) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *email = [defaults objectForKey:@"username"];
        NSString *message = [NSString stringWithFormat:@"email=%@&coursename=%@&totalstudents=%@",email,self.courseNameField.text,self.numStudentsField.text];
        NSDictionary *registrationDictionary = [self sendMessage:message toAddress:REG];
        if ([[registrationDictionary objectForKey:@"success"] integerValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
