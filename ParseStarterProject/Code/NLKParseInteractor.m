//
//  NLKParseInteractor.m
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/9/14.
//
//

#import "NLKParseInteractor.h"
#import <Parse/Parse.h>

@interface NLKParseInteractor ()


@end

@implementation NLKParseInteractor

- (void) createAccountWithEmail:(NSString *)email password:(NSString *)password userName:(NSString*)username
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.delegate userHasAuthenticated];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }];
}

- (void) logInWithUsername:(NSString *)username password:(NSString *)password;
{
    [PFUser logInWithUsernameInBackground:username
                                 password:password block:^(PFUser *user, NSError *error) {
                                     if (!error) {
                                         [self.delegate userHasAuthenticated];
                                     }
                                     else
                                     {
                                         NSString *errorString = [error userInfo][@"error"];
                                         [[[UIAlertView alloc] initWithTitle:@"Alert" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                                     }
                                 }];
}

- (void)logOut
{
    [PFUser logOut];
}

- (NSString *) username
{
    PFUser *user = [PFUser currentUser];
    return user.username;
}


@end
