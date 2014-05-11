//
//  CTVDataStore.m
//  ChalkTheVoteMobile
//
//  Created by Brandon Craig on 5/10/14.
//  Copyright (c) 2014 Brandon Craig. All rights reserved.
//

#import "CTVDataStore.h"
#define LOGIN @"http://chalkthevote.com/Trial/iosLoginCheck.php"
#define COURSELIST @"http://chalkthevote.com/Trial/iosCourseList.php"

@implementation CTVDataStore

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

-(BOOL) loginWithUsername: (NSString *) username password: (NSString *) password {
    //TODO change request string to ask for 'username' and not 'email'
    NSString *message = [NSString stringWithFormat:@"email=%@&password=%@",username,password];
    NSDictionary *response = [self sendMessage:message toAddress:LOGIN];
    if ([[response objectForKey:@"success"] integerValue] == 1) return YES;
    else return NO;
}


@end
