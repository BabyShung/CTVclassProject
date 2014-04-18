//
//  CTVViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 3/18/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVViewController.h"
#import "CTVClassesTableViewController.h"

#define LOGIN @"http://chalkthevote.com/Trial/iosLoginCheck.php"
#define COURSELIST @"http://chalkthevote.com/Trial/iosCourseList.php"

@interface CTVViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@end

@implementation CTVViewController
- (IBAction)registrationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

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

- (IBAction)sendField:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"email=%@&password=%@",self.usernameField.text,self.passwordField.text];
    NSDictionary *loginDictionary = [self sendMessage:message toAddress:LOGIN];
    if ([[loginDictionary objectForKey:@"success"] integerValue]==1) {
        NSDictionary *coursesDictionary = [self sendMessage:message toAddress:COURSELIST];
        [defaults setObject:self.usernameField.text forKey:@"username"];
        [defaults setObject:[NSMutableArray arrayWithArray:[coursesDictionary objectForKey:@"courselist"]] forKey:@"classlist"];
        [self performSegueWithIdentifier:@"login" sender:self];
    } else {
        self.errorField.text = @"Login Error: Try again";
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"login"]) {

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(self.view.frame.size);
    ;[[UIImage imageNamed:@"CTV_login_screen.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
