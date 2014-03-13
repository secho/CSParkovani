//
//  Parking.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "Parking.h"


static NSMutableDictionary *parkingsDictionary;
static NSMutableDictionary *trackedParkingsDictionary;
static int countOfupdatedParkings;
static int countOfParkingsForUpdate;
static BOOL updatingMultipleStatuses;

@implementation Parking

@synthesize delegate;
@synthesize name;

- (NSString *)truncatedName {
    NSArray *splits = [name componentsSeparatedByString:@"- "];
    return splits[splits.count-1];
}



+ (void)setDelegateForAllParkings:(id)newDelegate {
    for (NSArray *key in parkingsDictionary.allKeys) {
        Parking *parking = [parkingsDictionary objectForKey:key];
        parking.delegate = newDelegate;
    }
}

- (void)updateHistory {
    
}

- (void)updatePrediction {
    
}

+ (NSMutableDictionary *)trackedParkingsDictionary {
    return trackedParkingsDictionary;
}

+ (void)trackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId {
    if (trackedParkingsDictionary == nil) {
        trackedParkingsDictionary = [[NSMutableDictionary alloc] init];
    }
    [trackedParkingsDictionary setObject:[parkingsDictionary objectForKey:@[objectId,parkingId]]
                                  forKey:@[objectId,parkingId]];
}

+ (void)untrackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId {
    [trackedParkingsDictionary removeObjectForKey:@[objectId,parkingId]];
}


+ (void)updateTrackedParkings {
    NSLog(@"Update of tracked statuses has been invoked");
    updatingMultipleStatuses = YES;
    countOfParkingsForUpdate = trackedParkingsDictionary.allValues.count;
    for (NSArray *key in trackedParkingsDictionary.allKeys) {
        Parking *parking = [trackedParkingsDictionary objectForKey:key];
        [parking updateStatus];
    }
}


- (void)updateStatus {
    if(self.status == nil) {
        self.status =  [ParkingStatus initStatusWithParkingIdAndObjectId:self.parkingId objectId:self.objectId];
    }
    [self.status updateStatus:^(ParkingStatus *parkingStatus) {
        self.status = parkingStatus;
        [self didUpdatedStatus:self];
    } onFault:^(NSError *error) {
        NSLog(@"Update status failed!");
    }];
}

+ (void)updateAllStatuses {
    NSLog(@"Update of all statuses has been invoked");
    updatingMultipleStatuses = YES;
    countOfParkingsForUpdate = parkingsDictionary.allValues.count;
    for (NSArray *key in parkingsDictionary.allKeys) {
        Parking *parking = [parkingsDictionary objectForKey:key];
        [parking updateStatus];
    }
}


+ (NSMutableDictionary *)parkingsDictionary {
    return parkingsDictionary;
}

- (void)didUpdatedStatus:(Parking *)parking {
    [delegate didUpdatedStatus:self];
    if (updatingMultipleStatuses) {
        countOfupdatedParkings++;
        if (countOfupdatedParkings == countOfParkingsForUpdate) {
            [self didUpdatedStatusesForAllParkings];
        }
    }
}

- (void)didUpdatedStatusesForAllParkings {
    [delegate didUpdatedStatusesForAllParkings];
    updatingMultipleStatuses = NO;
    countOfupdatedParkings = 0;
}

+ (RKMapping *)mapping {
    RKObjectMapping *parkingMapping = [RKObjectMapping mappingForClass:[Parking class]];
    [parkingMapping addAttributeMappingsFromDictionary:@{
                                                         @"objectId" : @"objectId",
                                                         @"parkingId" : @"parkingId",
                                                         @"name" : @"name",
                                                         @"enabled" : @"enabled"
                                                         }];
    [parkingMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parkingObject"
                                                                                   toKeyPath:@"parkingObject"
                                                                                 withMapping:[ParkingObject mapping]]];
    return parkingMapping;
    
}

+ (void)parkings:(void (^)(NSArray *parkings))result onError:(void (^)(NSError *error))error {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[Parking mapping]
                                                method:RKRequestMethodAny
                                                pathPattern:nil
                                                keyPath:@""
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"places" parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  parkingsDictionary = [[NSMutableDictionary alloc] init];
                                                  for (Parking *parking in mappingResult.array) {
                                                      [parkingsDictionary setObject:parking
                                                                             forKey:@[parking.objectId,parking.parkingId]];
                                                  }
                                                  result(mappingResult.array);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *operationError) {
                                                  NSLog(@"fetch parkings failure");
                                                  error(operationError);
                                              }
     ];
}

@end

