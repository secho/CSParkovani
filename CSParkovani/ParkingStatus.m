//
//  ParkingStatus.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingStatus.h"
#import "RestKit.h"

@implementation ParkingStatus

+ (RKMapping *)mapping {
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[ParkingStatus class]];
    [statusMapping addAttributeMappingsFromDictionary:@{
                                                        @"presentTotal" : @"presentTotal",
                                                        @"presentVip" : @"presentVip",
                                                        @"limitTotal" : @"limitTotal",
                                                        @"reservedVip" : @"reservedVip",
                                                        @"semaphore" : @"semaphore"
                                                        }];
    return statusMapping;
}

+ (void)statuses:(void (^)(NSArray *statuses))result onError:(void (^)(NSError *error))error {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[ParkingStatus mapping]
                                                method:RKRequestMethodAny
                                                pathPattern:nil
                                                keyPath:@""
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"statuses" parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"success");
                                                  result(mappingResult.array);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *operationError) {
                                                  NSLog(@"failure");
                                                  error(operationError);
                                              }
     ];
}


+ (instancetype)initStatusWithParkingIdAndObjectId:(NSNumber *)parkingId objectId:(NSNumber *)objectId {
    ParkingStatus *parkingStatus = [[ParkingStatus alloc] init];
    parkingStatus.objectId = objectId;
    parkingStatus.parkingId = parkingId;
    return parkingStatus;
}

- (void)updateStatus:(void (^)(ParkingStatus *parkingStatus))result onFault:(void (^)(NSError *error))fault {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[ParkingStatus mapping]
                                                method:RKRequestMethodAny
                                                pathPattern:nil
                                                keyPath:@""
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] getObject:self
                                          path:@"status"
                                    parameters:@{@"objectId":self.objectId,@"parkingId":self.parkingId}
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           result(self);
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           fault(error);
                                           NSLog(@"status failure");
                                       }
     ];
}

- (NSNumber *)freePlaces
{
    NSInteger free;
    free = _limitTotal.integerValue - _presentTotal.integerValue;
    
    return [NSNumber numberWithInteger:free];
}

@end

