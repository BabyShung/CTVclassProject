//
//  CTVQBoardViewController.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 3/19/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVQBoardViewController.h"

@interface CTVQBoardViewController ()
@end

@implementation CTVQBoardViewController
{
    NSArray *questionArray;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.className;
}

@end
