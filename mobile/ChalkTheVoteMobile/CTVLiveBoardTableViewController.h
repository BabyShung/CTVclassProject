//
//  CTVLiveBoardTableViewController.h
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/2/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTVLiveBoardTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *questionArray;
@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *question;
@end