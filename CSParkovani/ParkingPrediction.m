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

#define LIMIT_AVERAGE_0 0.
#define LIMIT_AVERAGE_1 5.

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

- (parkAbility)willBeAbleToPark
{
    parkAbility result = parkAbilityUnknown;
    
    if (self.average)
    {
        float average = self.average.floatValue;
        
        if (average <= LIMIT_AVERAGE_0)
        {
            result = parkAbilityNo;
        }
        else if (LIMIT_AVERAGE_0 < average && average < LIMIT_AVERAGE_1)
        {
            result = parkAbilityAtRisk;
        }
        else if (LIMIT_AVERAGE_1 <= average)
        {
            result = parkAbilityYes;
        }
    }
    
    return result;
}

- (float)predictionPrecision
{
    float result = 0;
    
    if (self.yes && self.count)
    {
        result = self.yes.floatValue / self.count.floatValue;
    }
    
    return result;
}

+ (NSString *)messageForParkAbility:(parkAbility)parkAbility
{
    switch (parkAbility)
    {
        case parkAbilityYes:
            return @"ANO";
            
        case parkAbilityNo:
            return @"NE";
            
        case parkAbilityAtRisk:
            return @"riskantní";
            
        case parkAbilityUnknown:
            return @"--";
    }
}

@end
