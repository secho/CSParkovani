//
//  ChartView.h
//  CSParkovani
//
//  Created by Viktor Smidl on 16/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingStatistics.h"

@interface ChartView : UIView

@property (nonatomic) NSInteger totalParkingSlots;
@property (nonatomic, retain) NSArray *stats;

- (void)redrawChart;

@end
