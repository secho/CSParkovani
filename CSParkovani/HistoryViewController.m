//
//  HistoryViewController.m
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "HistoryViewController.h"
#import "NSDate+Tools.h"

@interface HistoryViewController ()
{
    NSDate *_firstDayOfWeek;
}

@property (nonatomic, retain) NSArray *stats;
@property (atomic) BOOL loadingData;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    if (!self.loadingData && self.parking && self.selectedDate)
    {
        self.loadingData = YES;
        [self.activityIndicator startAnimating];
        
        [self.parking asyncStatisticsForWeek:[self firstDayOfWeek] completition:^(NSArray *statistics) {
            
            self.stats = statistics;
            
            [self.activityIndicator stopAnimating];
            self.loadingData = NO;
            
        } onError:^(NSError *error) {
            
            self.stats = nil;
            
            [self.activityIndicator stopAnimating];
            self.loadingData = NO;
            
        }];
        
        self.chartView.totalParkingSlots = self.parking.status.limitTotal.integerValue;
    }
}

- (NSDate *)firstDayOfWeek
{
    return _firstDayOfWeek;
}

- (IBAction)segmentDayValueChanged:(UISegmentedControl *)sender
{
    _selectedDate = [[self firstDayOfWeek] dateWithDayOffset:sender.selectedSegmentIndex];
    
    [self drawChartForSelectedDate];
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    _firstDayOfWeek = [selectedDate firstDayOfTheWeek];
    
    [self.segmentDay setSelectedSegmentIndex:[selectedDate dayOfWeek]];
    
    [self updateAvailableDays];
    
    [self loadData];
}

- (void)setParking:(Parking *)parking
{
    _parking = parking;
    
    [self loadData];
}

- (void)setStats:(NSArray *)stats
{
    _stats = stats;
    
    [self drawChartForSelectedDate];
}

- (void)drawChartForSelectedDate
{
    //get date
    NSDate *date = self.selectedDate;
    NSTimeInterval startTimeInterval = [date timeIntervalSince1970];
    NSTimeInterval endTimeInterval = [[date dateWithDayOffset:1] timeIntervalSince1970];
    
    //get relevant stats
    NSMutableArray *relevantStats = [NSMutableArray array];
    
    for (ParkingStatistics *stat in self.stats)
    {
        NSTimeInterval statTime = stat.date.doubleValue / 1000;
        
        if (statTime >= startTimeInterval && statTime < endTimeInterval)
        {
            [relevantStats addObject:stat];
        }
    }
    
    //update UI
    self.labelDay.text = self.stats ? [date toStringWithFormat:@"dd'. 'MMMM' 'yyyy"] : @"Error";
    self.chartView.stats = relevantStats;
    
    [self updateAvailableDays];
}

- (void)updateAvailableDays
{
    NSDate *firstDayOfWeek = [self firstDayOfWeek];
    
    for (NSInteger i = 0; i < self.segmentDay.numberOfSegments; ++i)
    {
        NSDate *dateForSegment = [firstDayOfWeek dateWithDayOffset:i];
        BOOL enableSegment = [dateForSegment timeIntervalSinceNow] <= 0;
        
        [self.segmentDay setEnabled:enableSegment forSegmentAtIndex:i];
    }
}

@end
