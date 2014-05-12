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
#import "PSLocationManager.h"
#import <Parse/Parse.h>

@interface NLKNewTimeEntryViewController () <PSLocationManagerDelegate>

@property (strong) UILabel *timeLabel;
@property (strong) UILabel *distanceLabel;
@property (strong) UILabel *speedLabel;
@property (strong) UILabel *strengthLabel;

@property (strong) NSDate *startDate;
@property (strong) NSTimer *timer;
@property (strong) NSNumber *lastDistanceValue;

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
    
    [PSLocationManager sharedLocationManager].delegate = self;
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton*(^makeButton)(NSString*) = ^(NSString* title) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        {
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = [UIColor grayColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    UILabel *speedLabel = makeLabel(@"Speed: ");
    {
        self.speedLabel = speedLabel;
        [self.view addSubview:speedLabel];
    }
    
    UILabel *strengthLabel = makeLabel(@"Signal:");
    {
        self.strengthLabel = strengthLabel;
        [self.view addSubview:strengthLabel];
    }
    
    [self.view addConstraints:PVGroup(@[
                                        
                                        PVVFL(@"H:|-20-[startButton]-20-|"),
                                        PVVFL(@"H:|-20-[stopButton]-20-|"),
                                        PVVFL(@"H:|-20-[timeLabel]-20-|"),
                                        PVVFL(@"H:|-20-[distanceLabel]-20-|"),
                                        PVVFL(@"H:|-20-[speedLabel]-20-|"),
                                        PVVFL(@"H:|-20-[strengthLabel]-20-|"),
                                        PVVFL(@"V:|-30-[startButton(40)]-5-[stopButton(40)]-20-[timeLabel(20)]-5-[distanceLabel(20)]-5-[speedLabel(20)]-5-[strengthLabel(20)]")
                                        ]).withViews(NSDictionaryOfVariableBindings(stopButton, startButton, timeLabel, distanceLabel, speedLabel, strengthLabel)).asArray];
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
    [[PSLocationManager sharedLocationManager] resetLocationUpdates];
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
}

- (void) stop
{
    PFObject *timeUnit = [PFObject objectWithClassName:[NSString stringWithFormat:@"TimeUnit%@", [PFUser currentUser].username]];
    timeUnit[@"stopTime"] = [NSDate date];
    timeUnit[@"time"] = @([[NSDate date] timeIntervalSinceDate:self.startDate]);
    timeUnit[@"distance"] = self.lastDistanceValue;
    [timeUnit saveInBackground];
    
    [[PSLocationManager sharedLocationManager] stopLocationUpdates];

    self.startDate = nil;
    [self.timer invalidate];
}

- (void) tick
{
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", [self timeFormatted:[[NSDate date] timeIntervalSinceDate:self.startDate]]];
    
    double speed = [[PSLocationManager sharedLocationManager] currentSpeed];
    if (speed > 0) {
        self.speedLabel.text = [NSString stringWithFormat:@"Speed: %.2f m/s", speed];
    }
    else
    {
       self.speedLabel.text = @"Speed:";
    }
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    NSString *strengthText;
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        strengthText = NSLocalizedString(@"Signal: Weak", @"");
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        strengthText = NSLocalizedString(@"Signal: Strong", @"");
    } else {
        strengthText = NSLocalizedString(@"Signal: ...", @"");
    }
    
    self.strengthLabel.text = strengthText;
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    self.strengthLabel.text = NSLocalizedString(@"Signal: Consistently Weak", @"");
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    self.distanceLabel.text = [NSString stringWithFormat:@"Distance: %.2f %@", distance, NSLocalizedString(@"meters", @"")];
    self.lastDistanceValue = @(distance);
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
}

@end
