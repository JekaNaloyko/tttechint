//
//  NLKAPI.h
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/9/14.
//
//

#import <Foundation/Foundation.h>

@protocol NLKAPIDelegate

- (void) userHasAuthenticated;

@end

@protocol NLKAPI <NSObject>

- (void) createAccountWithEmail:(NSString *)email password:(NSString *)password userName:(NSString*)username;
- (void) logInWithUsername:(NSString *)username password:(NSString *)password;
- (void) logOut;

- (NSString *) username;

@end
