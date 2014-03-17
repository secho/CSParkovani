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

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *parkingType;
@property (weak, nonatomic) IBOutlet UILabel *freePlaces;
@property (weak, nonatomic) IBOutlet UILabel *totalPlaces;
@property (weak, nonatomic) IBOutlet UILabel *timeToFull;

@property (weak, nonatomic) IBOutlet UIView *historyView;

- (IBAction)prevWeekButtonClicked:(id)sender;
- (IBAction)nextWeekButtonClicked:(id)sender;

@end
