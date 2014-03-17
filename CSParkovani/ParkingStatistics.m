//
//  ParkingStatistics.m
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingStatistics.h"

@implementation ParkingStatistics

+ (RKObjectMapping *)mapping
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[ParkingStatistics class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"date":@"date",
                                                        @"free":@"free"
                                                        }];
    
    return objectMapping;
}

@end
