//
//  NLKTimeEntriesViewController.m
//  TopTalTechnicalInterview
//
//  Created by Ievgen Naloiko on 5/11/14.
//
//

#import "NLKTimeEntriesViewController.h"
#import <Parse/Parse.h>
#import <Parus/Parus.h>

@interface NLKTimeEntriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong) NSArray *objectsToDisplay;
@property (strong) UITableView *tableView;

@property (strong) NSArray *sectionHeaders;
@property (strong) NSMutableArray *objectsByWeeks;




@end

@implementation NLKTimeEntriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"All";
        self.tabBarItem.image = [UIImage imageNamed:@"text-list.png"];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"TimeUnit%@", [PFUser currentUser].username]];
    [query setLimit: 1000];
    //[query setSkip: 1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.objectsToDisplay = objects;
            [self recalculateWeeks];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor greenColor];
    
    UITableView *tableView = [UITableView new];
    {
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        [self setEditing:YES animated:NO];
        self.tableView = tableView;
        [self.view addSubview:tableView];
    }
    
    [self.view addConstraints:PVGroup(@[
                                        
                                        PVVFL(@"H:|[tableView]|"),
                                        PVVFL(@"V:|-20-[tableView]|")
                                        ]).withViews(NSDictionaryOfVariableBindings(tableView)).asArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *array = [self.objectsToDisplay mutableCopy];
        PFObject *object = array[indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"TimeUnit%@", [PFUser currentUser].username]];
                [query setLimit: 1000];
                //[query setSkip: 1000];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        self.objectsToDisplay = objects;
                        [self recalculateWeeks];
                        [self.tableView reloadData];
                    } else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        }];
        [array removeObjectAtIndex:indexPath.row];

        self.objectsToDisplay = array;
        [self recalculateWeeks];
        [self.tableView reloadData];
    }
    
    [self recalculateWeeks];
    [tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.objectsByWeeks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *week = self.objectsByWeeks[section];
    return week.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:MyIdentifier];
    }
    
    PFObject *object = self.objectsToDisplay[indexPath.row];
    
    NSDate *stopTime = object[@"stopTime"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", stopTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fm %.2fs",[object[@"distance"] floatValue], [object[@"time"] floatValue]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


#pragma mark UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = self.sectionHeaders[section];//[list objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (BOOL) weekIsEqual:(NSDate *)date and:(NSDate *)otherDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents      = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSDateComponents *otherDateComponents = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit fromDate:otherDate];
    
    return [dateComponents week] == [otherDateComponents week] && [dateComponents year] == [otherDateComponents year];
}

- (void)recalculateWeeks
{
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"stopTime"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray *sortedObjectsArray = [[self.objectsToDisplay
                                 sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSMutableArray *statistics = [NSMutableArray new];
    NSMutableArray *weeks = [NSMutableArray new];
    
    CGFloat distance = 0;
    CGFloat time = 0;
    
    PFObject *object = sortedObjectsArray.firstObject;
    NSDate* lastObjectDate = object[@"stopTime"];
    
    
    NSMutableArray *oneWeek = [NSMutableArray new];
    
    while (sortedObjectsArray.firstObject) {
        PFObject *object = sortedObjectsArray.firstObject;
        if ([self weekIsEqual:object[@"stopTime"] and:lastObjectDate]) {
            [oneWeek addObject:object];
            distance += [object[@"distance"] floatValue];
            time += [object[@"time"] floatValue];
        }
        else
        {
            [weeks addObject:oneWeek];
            [statistics addObject:[NSString stringWithFormat:@"avg spped: %.2f m/s; avg dist: %.2f", distance/time, distance/oneWeek.count]];
            oneWeek = [NSMutableArray new];
            distance = 0;
            time = 0;
            [oneWeek addObject:object];
            distance += [object[@"distance"] floatValue];
            time += [object[@"time"] floatValue];
        }
        
        lastObjectDate = object[@"stopTime"];
        
        [sortedObjectsArray removeObject:object];
    }
    
    [weeks addObject:oneWeek];
    
    if (distance > 0) {
        [statistics addObject:[NSString stringWithFormat:@"avg spped: %.2f m/s; avg dist: %.2f", distance/time, distance/oneWeek.count]];
    }
    else
    {
        [statistics addObject:@""];
    }

    
    self.sectionHeaders = statistics;
    self.objectsByWeeks = weeks;
    
}

@end
