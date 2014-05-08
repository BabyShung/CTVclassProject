//
//  CTVViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 3/18/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVViewController.h"
#import "CTVClassesTableViewController.h"
#import <QuartzCore/QuartzCore.h>

#define LOGIN @"http://chalkthevote.com/Trial/iosLoginCheck.php"
#define COURSELIST @"http://chalkthevote.com/Trial/iosCourseList.php"
#define SESSION @"http://chalkthevote.com/Trial/iosSessionClose.php"

@interface CTVViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *CTVlogo;
@property (weak, nonatomic) IBOutlet UIImageView *usernameIMG;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIMG;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@end

@implementation CTVViewController


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

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    //self.view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(self.view.frame.size);
    ;[[UIImage imageNamed:@"CTV_app_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBar.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageToMove = self.CTVlogo;
    UIImageView *imageToMove2 = self.usernameIMG;
    UIImageView *imageToMove3 = self.passwordIMG;
    imageToMove.frame = CGRectMake(10, 10, 200, 1000);
    [self.view addSubview:imageToMove];
    [self.view addSubview:imageToMove2];
    [self.view addSubview:imageToMove3];
    
   
    
    [self moveImage:imageToMove duration:1.0
              curve:UIViewAnimationCurveLinear x:0.0 y:5.0];
   
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ChalkTheVote Alpha Release"
                                                    message:@"Welcome to the CTV alpha release. It is recomended testing is done on the 4 inch iPhone. Add this course: 'er45' to get started."
                                                   delegate:nil
                                          cancelButtonTitle:@"Got it"
                                          otherButtonTitles:nil];
    [alert show];
*/
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    if ([user length] > 0) {
        NSString *message = [NSString stringWithFormat:@"email=%@", user];
        [self sendMessage:message toAddress:SESSION];
        [defaults setObject:@"" forKey:@"username"];
    }
    
}

-(void)makeViewShine:(UIView*) view
{
    view.layer.shadowColor = [UIColor clearColor].CGColor;
    view.layer.shadowRadius = 10.0f;
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowOffset = CGSizeZero;
    
    
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:15];
        
        view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
        
    } completion:^(BOOL finished) {
        
        view.layer.shadowRadius = 0.0f;
        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
    
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
