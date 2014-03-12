//
//  ParkingDelegate.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Parking;

@protocol ParkingDelegate <NSObject>

- (void) didUpdatedStatus:(Parking *)parking;
- (void) didUpdatedStatusesForAllParkings;


@end
