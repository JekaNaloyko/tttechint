//
//  NLKParseInteractor.h
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/9/14.
//
//

#import <Foundation/Foundation.h>
#import "NLKAPI.h"

@interface NLKParseInteractor : NSObject <NLKAPI>

@property(nonatomic, retain) id <NLKAPIDelegate> delegate;

@end
