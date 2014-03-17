//
//  ParkingPrediction.m
//  CSParkovani
//
//  Created by Viktor Smidl on 17/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingPrediction.h"
#import "LocationService.h"
#import "NSDate+Tools.h"

@implementation ParkingPrediction

+ (instancetype)predictionWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId
{
    return [[self alloc] initWithParkingId:parkingId objectId:objectId];
}

+ (RKMapping *)mapping
{
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[ParkingPrediction class]];
    [statusMapping addAttributeMappingsFromDictionary:@{
                                                        @"parkingFk" : @"parkingFk",
                                                        @"time" : @"time",
                                                        @"weekDay" : @"weekDay",
                                                        @"count" : @"count",
                                                        @"yes" : @"yes",
                                                        @"median" : @"median",
                                                        @"average" : @"average"
                                                        }];
    return statusMapping;
}

- (id)initWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId
{
    self = [super init];
    
    if (self)
    {
        self.parkingId = parkingId;
        self.objectId = objectId;
    }
    
    return self;
}

- (void)updatePrediction:(void (^)(ParkingPrediction *))result onFault:(void (^)(NSError *))fault
{
    NSDate *date = self.date;
    NSNumber *day = [NSNumber numberWithInt:(int)[date dayOfWeek] + 1];
    NSString *time = [date toStringWithFormat:@"hh':'mm"];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ParkingPrediction mapping]
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] getObject:self
                                          path:@"prediction"
                                    parameters:@{ @"objectId":self.objectId, @"parkingId":self.parkingId, @"time":time, @"day":day }
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           
                                           result(self);
                                           
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           
                                           fault(error);
                                           NSLog(@"prediction failure");
                                           
                                       }
     
     ];
}

@end
