//
//  CTVRegistrationViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/3/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVRegistrationViewController.h"

#define REGISTER @"http://www.chalkthevote.com/Trial/iosRegisterUser.php"
#define COURSELIST @"http://chalkthevote.com/Trial/iosCourseList.php"

@interface CTVRegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation CTVRegistrationViewController

- (UITextField*)usernameField{

    self.view.backgroundColor = [UIColor clearColor];
    return _usernameField;
}
- (IBAction)registerButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"username=%@&email=%@&password=%@",self.usernameField.text,self.emailField.text,self.passwordField.text];
    NSDictionary *registrationDictionary = [self sendMessage:message toAddress:REGISTER];
    if ([[registrationDictionary objectForKey:@"success"] integerValue]==1) {
        NSDictionary *coursesDictionary = [self sendMessage:message toAddress:COURSELIST];
        [defaults setObject:self.usernameField.text forKey:@"username"];
        [defaults setObject:[NSMutableArray arrayWithArray:[coursesDictionary objectForKey:@"courselist"]] forKey:@"classlist"];
        [self performSegueWithIdentifier:@"registerLogin" sender:self];
    }
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

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Register New Account";
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
