//
//  CTVViewQuestionViewController.h
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 4/2/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTVViewQuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSString *qID;
@property (nonatomic,strong) NSString *qVotes;
@property (nonatomic,strong) NSString *classname;
@property BOOL moderatorMode;
@end
