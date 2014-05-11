//
//  AuthorizationViewController.h
//  ParseStarterProject
//
//  Created by Ievgen Naloiko on 5/9/14.
//
//

#import <UIKit/UIKit.h>
#import "NLKParseInteractor.h"

@interface NLKAuthorizationViewController : UIViewController <NLKAPIDelegate>

@property (strong) NLKParseInteractor *parseInteractor;

@end
