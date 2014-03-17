//
//  LocationService.h
//  CSParkovani
//
//  Created by Viktor Smidl on 17/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject

+ (instancetype)sharedInstance;

- (void)startUpdating;
- (void)stopUpdating;
- (CLLocation *)lastKnownLocation;
- (void)asyncGetRouteDirectionByCarToLocation:(CLLocationCoordinate2D)toLocation completition:(void (^)(NSTimeInterval, NSError *))completitionBlock;

@end
