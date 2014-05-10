//
//  CTVCreateClassViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 5/9/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVCreateClassViewController.h"
#define REG @"http://chalkthevote.com/Trial/iosRegisterCourse.php"


@interface CTVCreateClassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *classNameField;
@property (weak, nonatomic) IBOutlet UITextField *numStudentsField;
@property (weak, nonatomic) IBOutlet UIImageView *gear1;
@property (weak, nonatomic) IBOutlet UIImageView *gear2;

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

- (IBAction)submitButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *message = [NSString stringWithFormat:@"email=%@&coursename=%@&totalstudents=%@",[defaults objectForKey:@"username"],self.classNameField.text, self.numStudentsField.text];
    NSDictionary *registrationDictionary = [self sendMessage:message toAddress:REG];
    if ([[registrationDictionary objectForKey:@"success"] intValue] == 1) {
        
        
        //-----Gear Animation ----
        
        CABasicAnimation *rotation;
        rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = [NSNumber numberWithFloat:0];
        rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
        rotation.duration = 1.1; // Speed
        rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        
        CABasicAnimation *rotation2;
        rotation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation2.fromValue = [NSNumber numberWithFloat:(2*M_PI)];
        rotation2.toValue = [NSNumber numberWithFloat:0];
        rotation2.duration = 1.1; // Speed
        rotation2.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        
        [self.gear1.layer addAnimation:rotation forKey:@"Spin"];
        [self.gear2.layer addAnimation:rotation2 forKey:@"Spin"];
        
        //------------------------
        
        
        
        [self performSegueWithIdentifier:@"successfulRegistration" sender:self];
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
    // Do any additional setup after loading the view.
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    ;[[UIImage imageNamed:@"CTV_app_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 15.1; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    
    CABasicAnimation *rotation2;
    rotation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation2.fromValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation2.toValue = [NSNumber numberWithFloat:0];
    rotation2.duration = 15.1; // Speed
    rotation2.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    
    [self.gear1.layer addAnimation:rotation forKey:@"Spin"];
    [self.gear2.layer addAnimation:rotation2 forKey:@"Spin"];
    
    
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
