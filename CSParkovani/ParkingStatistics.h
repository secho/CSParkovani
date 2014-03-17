//
//  ParkingStatistics.h
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface ParkingStatistics : NSObject

@property(nonatomic, copy) NSNumber *date;
@property(nonatomic, copy) NSNumber *free;

+ (RKObjectMapping *)mapping;

@end
