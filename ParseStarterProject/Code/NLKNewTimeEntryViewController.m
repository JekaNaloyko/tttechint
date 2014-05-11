//
//  NLKNewTimeEntryViewController.m
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/11/14.
//
//

#import "NLKNewTimeEntryViewController.h"

@interface NLKNewTimeEntryViewController ()

@end

@implementation NLKNewTimeEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New";
        self.tabBarItem.image = [UIImage imageNamed:@"stopwatch.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
   
    [self buildView];
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
