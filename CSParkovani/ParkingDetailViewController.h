//
//  ParkingDetailViewController.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parking.h"
#import "HistoryViewController.h"

@interface ParkingDetailViewController : UIViewController

@property (nonatomic, strong) Parking *parking;
@property (nonatomic, strong) HistoryViewController *historyViewController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UILabel *location;
@property (retain, nonatomic) IBOutlet UILabel *parkingType;
@property (retain, nonatomic) IBOutlet UILabel *freePlaces;
@property (retain, nonatomic) IBOutlet UILabel *totalPlaces;
@property (retain, nonatomic) IBOutlet UILabel *timeToFull;
@property (retain, nonatomic) IBOutlet UILabel *arrivalTime;
@property (retain, nonatomic) IBOutlet UILabel *willPark;
@property (retain, nonatomic) IBOutlet UILabel *predictionPrecision;

@property (weak, nonatomic) IBOutlet UIView *historyView;

- (IBAction)prevWeekButtonClicked:(id)sender;
- (IBAction)nextWeekButtonClicked:(id)sender;
- (IBAction)navigateButtonClicked:(id)sender;

@end
