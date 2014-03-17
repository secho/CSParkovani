//
//  HistoryViewController.h
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parking.h"
#import "ChartView.h"

@interface HistoryViewController : UIViewController

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) Parking *parking;

@property (strong, nonatomic) IBOutlet UILabel *labelDay;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentDay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet ChartView *chartView;

- (NSDate *)firstDayOfWeek;
- (IBAction)segmentDayValueChanged:(UISegmentedControl *)sender;

@end
