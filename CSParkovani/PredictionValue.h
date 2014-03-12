//
//  PredictionValue.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface PredictionValue : NSObject

@property (nonatomic, copy) NSNumber *parkingFK;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *weekDay;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSNumber *yes;
@property (nonatomic, copy) NSNumber *median;
@property (nonatomic, copy) NSNumber *average;


+ (RKMapping *) mapping;
- (void) updatePrediction:(void (^)(PredictionValue *))result onFault:(void (^)(NSError *))fault;
@end