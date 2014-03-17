//
//  Parking.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "Parking.h"
#import "NSDate+Tools.h"
#import "LocationService.h"

#define USER_TRACKED_PARKINGS_KEY @"userTrackedParkings"

static NSMutableDictionary *parkingsDictionary;
static NSMutableDictionary *trackedParkingsDictionary;
static int countOfupdatedParkings;
static int countOfParkingsForUpdate;
static BOOL updatingMultipleStatuses;

@implementation Parking

@synthesize delegate;
@synthesize name;

- (NSString *)truncatedName
{
    NSArray *splits = [name componentsSeparatedByString:@"- "];
    return splits[splits.count - 1];
}

+ (void)setDelegateForAllParkings:(id)newDelegate
{
    for (NSArray *key in parkingsDictionary.allKeys)
    {
        Parking *parking = [parkingsDictionary objectForKey:key];
        parking.delegate = newDelegate;
    }
}

- (void)asyncStatisticsForWeek:(NSDate *)firstDayDate completition:(void (^)(NSArray *statistics))result onError:(void (^)(NSError *error))error
{
    NSDate *fromDate = [firstDayDate midnightDate];
    NSDate *toDate = [fromDate dateWithDayOffset:7];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[ParkingStatistics mapping]
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"statistic/hourly"
                                           parameters:@{ @"objectId":self.objectId,
                                                         @"parkingId":self.parkingId,
                                                         @"from":[fromDate toStringWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"],
                                                         @"to":[toDate toStringWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]
                                                         }
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"stats downloaded");
                                                  result(mappingResult.array);
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *operationError) {
                                                  
                                                  NSLog(@"download statistics failure");
                                                  error(operationError);
                                                  
                                              }];
}

- (void)updateHistory
{
    
}

- (void)updatePrediction
{
    
    if (!self.prediction)
    {
        self.prediction = [ParkingPrediction predictionWithParkingId:self.parkingId objectId:self.objectId];
    }

    ParkingPrediction *prediction = self.prediction;
    CLLocationCoordinate2D targetLocation = CLLocationCoordinate2DMake(self.parkingObject.latitude.floatValue, self.parkingObject.longitude.floatValue);
    
    [[LocationService sharedInstance] asyncGetRouteDirectionByCarToLocation:targetLocation completition:^(NSTimeInterval duration, NSError *error) {
        
        if (error)
        {
            NSLog(@"Update distance failed!");
            return;
        }
    
        NSDate *expectedArrivalDate = [NSDate dateWithTimeIntervalSinceNow:duration];
        prediction.date = expectedArrivalDate;
        
        [prediction updatePrediction:^(ParkingPrediction *parkingPrediction) {
            
            self.prediction = parkingPrediction;
            [self didUpdatePrediction:self];
            
        } onFault:^(NSError *error) {
            
            NSLog(@"Update prediction failed!");
            
        }];
        
    }];
}

+ (NSMutableDictionary *)trackedParkingsDictionary
{
    return trackedParkingsDictionary;
}

+ (void)trackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId
{
    if (trackedParkingsDictionary == nil)
    {
        trackedParkingsDictionary = [NSMutableDictionary dictionary];
    }
    
    [trackedParkingsDictionary setObject:[parkingsDictionary objectForKey:@[objectId, parkingId]] forKey:@[objectId, parkingId]];
}

+ (void)untrackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId
{
    [trackedParkingsDictionary removeObjectForKey:@[objectId, parkingId]];
}

+ (void)loadTrackedParkings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *trackedParkings = [userDefaults valueForKey:USER_TRACKED_PARKINGS_KEY];
    
    for (NSArray *trackedParking in trackedParkings)
    {
        if (trackedParking.count >= 2)
        {
            [self trackParkingWithParkingId:trackedParking[1] objectId:trackedParking[0]];
        }
    }
    
    //fill default parkings if wanted
    if (!trackedParkings)
    {
        [self trackParkingWithParkingId:@5 objectId:@15];
        [self trackParkingWithParkingId:@3 objectId:@6];
        [self saveTrackedParkings];
    }
}

+ (void)saveTrackedParkings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *trackedParkings = trackedParkingsDictionary.allKeys;
    
    [userDefaults setValue:trackedParkings forKey:USER_TRACKED_PARKINGS_KEY];
    [userDefaults synchronize];
}

+ (void)updateTrackedParkings
{
    NSLog(@"Update of tracked statuses has been invoked");
    updatingMultipleStatuses = YES;
    countOfParkingsForUpdate = trackedParkingsDictionary.allValues.count;
    
    for (NSArray *key in trackedParkingsDictionary.allKeys)
    {
        Parking *parking = [trackedParkingsDictionary objectForKey:key];
        [parking updateStatus];
        [parking updatePrediction];
    }
}

- (void)updateStatus
{
    if (self.status == nil)
    {
        self.status =  [ParkingStatus initStatusWithParkingIdAndObjectId:self.parkingId objectId:self.objectId];
    }
    
    [self.status updateStatus:^(ParkingStatus *parkingStatus) {
        
        self.status = parkingStatus;
        [self didUpdatedStatus:self];
        
    } onFault:^(NSError *error) {
        
        NSLog(@"Update status failed!");
        
    }];
}

+ (void)updateAllStatuses
{
    NSLog(@"Update of all statuses has been invoked");
    updatingMultipleStatuses = YES;
    countOfParkingsForUpdate = parkingsDictionary.allValues.count;

    for (NSArray *key in parkingsDictionary.allKeys)
    {
        Parking *parking = [parkingsDictionary objectForKey:key];
        [parking updateStatus];
    }
}

+ (void)updateTrackedParkingsPredictions
{
    for (NSArray *key in trackedParkingsDictionary.allKeys)
    {
        Parking *parking = [trackedParkingsDictionary objectForKey:key];
        [parking updatePrediction];
    }
}

+ (NSMutableDictionary *)parkingsDictionary
{
    return parkingsDictionary;
}

- (void)didUpdatePrediction:(Parking *)parking
{
    if (delegate && [delegate respondsToSelector:@selector(didUpdatePrediction:)])
    {
        [delegate didUpdatePrediction:self];
    }
}

- (void)didUpdatedStatus:(Parking *)parking
{
    [delegate didUpdatedStatus:self];

    if (updatingMultipleStatuses)
    {
        countOfupdatedParkings++;
        
        if (countOfupdatedParkings == countOfParkingsForUpdate)
        {
            [self didUpdatedStatusesForAllParkings];
        }
    }
}


- (void)didUpdatedStatusesForAllParkings
{
    [delegate didUpdatedStatusesForAllParkings];
    updatingMultipleStatuses = NO;
    countOfupdatedParkings = 0;
}

+ (RKMapping *)mapping
{
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
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Parking mapping]
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@""
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"places"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  parkingsDictionary = [[NSMutableDictionary alloc] init];
                                                  
                                                  for (Parking *parking in mappingResult.array)
                                                  {
                                                      [parkingsDictionary setObject:parking forKey:@[parking.objectId,parking.parkingId]];
                                                  }
                                                  
                                                  result(mappingResult.array);
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *operationError) {

                                                  NSLog(@"fetch parkings failure");
                                                  error(operationError);
                                                  
                                              }];
}

@end

