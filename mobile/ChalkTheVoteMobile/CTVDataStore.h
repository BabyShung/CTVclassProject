//
//  CTVDataStore.h
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 5/10/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTVDataStore : NSObject
-(BOOL) loginWithUsername: (NSString *) username password: (NSString *) password;
@end
