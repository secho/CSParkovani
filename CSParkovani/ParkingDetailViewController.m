//
//  ParkingDetailViewController.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingDetailViewController.h"
#import "NSDate+Tools.h"
#import <MapKit/MapKit.h>

#define HISTORY_SWITCH_ANIMATION_DURATION .3
#define CONTENT_SIZE 568.

typedef enum {
  
    HistoryViewPresentationNone,
    historyViewPresentationRight,
    HistoryViewPresentationLeft
    
} HistoryViewPresentation;

@interface ParkingDetailViewController ()

@end

@implementation ParkingDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize newContetnSize = self.scrollView.contentSize;
    newContetnSize.height = CONTENT_SIZE;
    self.scrollView.contentSize = newContetnSize;
    
    [self updateAppearance];
    
    [self setUpHistoryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setParking:(Parking *)parking
{
    _parking = parking;
    
    [self updateAppearance];
}

- (void)updateAppearance
{
    Parking *parkingModel = self.parking;
    
    self.location.text = parkingModel.parkingObject.name;
    self.parkingType.text = parkingModel.truncatedName;
    self.freePlaces.text = parkingModel.status.freePlaces.description;
    self.totalPlaces.text = [NSString stringWithFormat:@"míst volných\nz celkových %d", parkingModel.status.limitTotal.intValue];
    self.arrivalTime.text = parkingModel.prediction.date ? [parkingModel.prediction.date toStringWithFormat:@"hh':'mm"] : @"N/A";
}

- (void)showHistoryForThisWeek
{
    HistoryViewController *newHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyView"];
    [self presentHistoryViewController:newHistoryViewController withPresentation:HistoryViewPresentationNone];
    newHistoryViewController.selectedDate = [[NSDate date] midnightDate];
    newHistoryViewController.parking = self.parking;
}

- (void)showHistoryForNextWeek
{
    NSDate *date = self.historyViewController.selectedDate;
    date = [date dateWithDayOffset:7];
    
    [self showHistoryForDay:date presentAsNext:YES];
}

- (void)showHistoryForPreviousWeek
{
    NSDate *date = self.historyViewController.selectedDate;
    date = [date dateWithDayOffset:-7];
    
    [self showHistoryForDay:date presentAsNext:NO];
}

- (void)showHistoryForDay:(NSDate *)date presentAsNext:(BOOL)presentAsNext
{
    HistoryViewController *newHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyView"];
    [self presentHistoryViewController:newHistoryViewController withPresentation:presentAsNext ? historyViewPresentationRight : HistoryViewPresentationLeft];
    newHistoryViewController.selectedDate = [date midnightDate];
    newHistoryViewController.parking = self.parking;
}

- (void)presentHistoryViewController:(HistoryViewController *)historyViewController withPresentation:(HistoryViewPresentation)presentation
{
    //bind old history view vontroller
    HistoryViewController *oldHistoryViewController = self.historyViewController;
    UIView *oldHistoryView = oldHistoryViewController.view;
    
    //add new history view controller
    self.historyViewController = historyViewController;
    UIView *newHistoryView = historyViewController.view;
    
    [historyViewController willMoveToParentViewController:self];
    [self addChildViewController:historyViewController];
    [historyViewController viewWillAppear:NO];
    
    newHistoryView.frame = self.historyView.bounds;
    [self.historyView addSubview:newHistoryView];
    
    [historyViewController viewDidAppear:NO];
    [historyViewController didMoveToParentViewController:self];
    
    //switch history views
    CGFloat directonSgn = presentation == historyViewPresentationRight ? 1. : -1.;
    
    newHistoryView.transform = CGAffineTransformMakeTranslation(directonSgn * newHistoryView.frame.size.width, 0);
    
    void (^blockToBeAnimated)(void) = ^(void){
     
        newHistoryView.transform = CGAffineTransformIdentity;
        oldHistoryView.transform = CGAffineTransformMakeTranslation(- directonSgn * oldHistoryView.frame.size.width, 0);
        
    };
    
    void (^blockAfterAnimation)(BOOL) = ^(BOOL finished) {
        
        //remove old history view
        [oldHistoryViewController willMoveToParentViewController:nil];
        [oldHistoryViewController viewWillDisappear:NO];
        [oldHistoryView removeFromSuperview];
        [oldHistoryViewController viewDidDisappear:NO];
        [oldHistoryViewController removeFromParentViewController];
        
    };
    
    if (!oldHistoryViewController || presentation == HistoryViewPresentationNone)
    {
        //avoid animation
        blockToBeAnimated();
        blockAfterAnimation(NO);
    }
    else
    {
        //slide animation
        [UIView animateWithDuration:HISTORY_SWITCH_ANIMATION_DURATION delay:0. options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:blockToBeAnimated completion:blockAfterAnimation];
    }
}

- (void)setUpHistoryView
{
    UISwipeGestureRecognizer *swipeGesture;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleHistoryViewSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.historyView addGestureRecognizer:swipeGesture];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleHistoryViewSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.historyView addGestureRecognizer:swipeGesture];
    
    [self showHistoryForThisWeek];
}

- (void)handleHistoryViewSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self showHistoryForNextWeek];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self showHistoryForPreviousWeek];
    }
}

- (void)prevWeekButtonClicked:(id)sender
{
    [self showHistoryForPreviousWeek];
}

- (void)nextWeekButtonClicked:(id)sender
{
    [self showHistoryForNextWeek];
}

- (void)navigateButtonClicked:(id)sender
{
    CLLocationCoordinate2D targetLocation = CLLocationCoordinate2DMake(self.parking.parkingObject.latitude.floatValue, self.parking.parkingObject.longitude.floatValue);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:targetLocation addressDictionary:nil];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    [endItem openInMapsWithLaunchOptions:launchOptions];
}

@end
