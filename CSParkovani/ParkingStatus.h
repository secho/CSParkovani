//
//  ParkingStatus.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface ParkingStatus : NSObject

@property(nonatomic, copy) NSNumber *parkingId;
@property(nonatomic, copy) NSNumber *objectId;
@property(nonatomic, copy) NSNumber *presentTotal;
@property(nonatomic, copy) NSNumber *presentVip;
@property(nonatomic, copy) NSNumber *limitTotal;
@property(nonatomic, copy) NSNumber *reservedVip;
@property(nonatomic, copy) NSString *semaphore;

+ (void)statuses:(void (^)(NSArray *statuses))result onError:(void (^)(NSError *error))error;
+ (RKMapping *)mapping;
+ (instancetype)initStatusWithParkingIdAndObjectId:(NSNumber *)parkingId objectId:(NSNumber *)objectId;
- (void)updateStatus:(void(^)(ParkingStatus *parkingStatus))result onFault:(void(^)(NSError *error))fault;
- (NSNumber *)freePlaces;

@end
