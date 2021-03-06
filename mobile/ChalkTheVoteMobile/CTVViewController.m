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
#import "CTVDataStore.h"

@interface CTVViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *CTVlogo;
@property (weak, nonatomic) IBOutlet UIImageView *usernameIMG;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIMG;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@property (strong, nonatomic) NSString *username;
@property (nonatomic)  CTVDataStore *dataStore;
@end

@implementation CTVViewController

- (CTVDataStore *) dataStore {
    if (!_dataStore) {
        _dataStore = [[CTVDataStore alloc] init];
    }
    return _dataStore;
}

- (IBAction)registrationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

- (IBAction)sendField:(id)sender {
    if ([self.dataStore loginWithUsername:self.usernameField.text password:self.passwordField.text]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.usernameField.text forKey:@"username"];
        [self performSegueWithIdentifier:@"login" sender:self];
    } else {
        //TODO: Create a method called -(NSString *) getLoginErrorForUsername: (NSString *) username password: (NSString *) password {}; to return error.
        self.errorField.text = @"Login Error: Try again";
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
    
    
    // Paralax Effects
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.view  addMotionEffect:group]; // might change to logo
   
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ChalkTheVote Alpha Release"
                                                    message:@"Welcome to the CTV alpha release. It is recomended testing is done on the 4 inch iPhone. Add this course: 'er45' to get started."
                                                   delegate:nil
                                          cancelButtonTitle:@"Got it"
                                          otherButtonTitles:nil];
    [alert show];
*/
    
    
    
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
