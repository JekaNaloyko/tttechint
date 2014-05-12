//
//  NLKNewTimeEntryViewController.m
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/11/14.
//
//

#import "NLKNewTimeEntryViewController.h"
#import <Parus/Parus.h>
#import <MSWeakTimer/MSWeakTimer.h>

@interface NLKNewTimeEntryViewController ()

@property (strong) UILabel *timeLabel;
@property (strong) UILabel *distanceLabel;

@property (strong) NSDate *startDate;
@property (strong) NSTimer *timer;

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
    
    UIButton*(^makeButton)(NSString*) = ^(NSString* title) {
        UIButton *button = [UIButton new];
        {
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = [UIColor grayColor];
            [button setTitle:title forState:UIControlStateNormal];
        }
        return button;
    };
    
    UIButton *startButton = makeButton(@"Start");
    {
        [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startButton];
    }
    
    UIButton *stopButton = makeButton(@"Stop");
    {
        [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:stopButton];
    }
    
    UILabel*(^makeLabel)(NSString*) = ^(NSString* title) {
        UILabel *label = [UILabel new];
        {
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.backgroundColor = [UIColor clearColor];
            label.text = title;
        }
        return label;
    };
    
    UILabel *timeLabel = makeLabel(@"Time: ");
    {
        self.timeLabel = timeLabel;
        [self.view addSubview:timeLabel];
    }
    
    UILabel *distanceLabel = makeLabel(@"Distance: ");
    {
        self.distanceLabel = distanceLabel;
        [self.view addSubview:distanceLabel];
    }
    
    [self.view addConstraints:PVGroup(@[
                                        
                                        PVVFL(@"H:|-20-[startButton]-20-|"),
                                        PVVFL(@"H:|-20-[stopButton]-20-|"),
                                        PVVFL(@"H:|-20-[timeLabel]-20-|"),
                                        PVVFL(@"H:|-20-[distanceLabel]"),
                                        PVVFL(@"V:|-20-[startButton(40)]-5-[stopButton(40)]-20-[timeLabel(20)]-5-[distanceLabel(20)]")
                                        ]).withViews(NSDictionaryOfVariableBindings(stopButton, startButton, timeLabel, distanceLabel)).asArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) start
{
    self.startDate = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void) stop
{
    self.startDate = nil;
    [self.timer invalidate];
    NSDate *stopDate = [NSDate date];
    
}

- (void) tick
{
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", [self timeFormatted:[[NSDate date] timeIntervalSinceDate:self.startDate]]];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
