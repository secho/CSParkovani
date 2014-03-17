//
//  ParkingPrediction.h
//  CSParkovani
//
//  Created by Viktor Smidl on 17/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface ParkingPrediction : NSObject

@property(nonatomic, copy) NSNumber *parkingId;
@property(nonatomic, copy) NSNumber *objectId;
@property(nonatomic, copy) NSDate *date;
@property(nonatomic, copy) NSNumber *parkingFk;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *weekDay;
@property(nonatomic, copy) NSNumber *count;
@property(nonatomic, copy) NSNumber *yes;
@property(nonatomic, copy) NSNumber *median;
@property(nonatomic, copy) NSNumber *average;

+ (instancetype)predictionWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId;
+ (RKMapping *)mapping;

- (id)initWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId;
- (void)updatePrediction:(void (^)(ParkingPrediction *))result onFault:(void (^)(NSError *))fault;

@end
