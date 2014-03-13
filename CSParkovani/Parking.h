//
//  Parking.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>
#import "ParkingObject.h"
#import "ParkingStatus.h"
#import "ParkingDelegate.h"

@interface Parking : NSObject <ParkingDelegate>

@property (nonatomic, assign) id delegate; /**< class delegate*/
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *objectId;
@property (nonatomic, copy) NSNumber *parkingId;
@property (nonatomic, copy) NSString *enabled;
@property ParkingObject *parkingObject;
@property ParkingStatus *status;

/**
 * Return truncated name of the Parking object. Last part of 'P3 - Polackova - ostatni' will be returned.
 */
- (NSString *)truncatedName;


/**
 * Invokes status update of the Parking instance.
 */
- (void) updateStatus;

/**
 * Invokes history update of the Parking instance.
 */
- (void) updateHistory;

/**
 * Inovkes prediction update of the Parking instance.
 */
- (void) updatePrediction;

/**
 * Get all parking objects from REST API. After response is returned fill parkingsDictionary and callback.
 */
+ (void)parkings: (void (^)(NSArray *parkings))result onError:(void (^)(NSError *error))error;

/*
 Get dictionary of all parking objects where key is [objectId, parkingId]
 */
+ (NSMutableDictionary *) parkingsDictionary;

/**
 * Get dictionary of tracked parking objects. This dictionary contains parking objects selected for monitoring
 * and updating. Key is [objectId, parkingId]
 */
+ (NSMutableDictionary *) trackedParkingsDictionary;

/**
 * Add parking object into trackedParkingsDictionary.
 */
+ (void)trackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId;

/**
* Remove parking object from trackedParkingsDictionary.
*/
+ (void)untrackParkingWithParkingId:(NSNumber *)parkingId objectId:(NSNumber *)objectId;


/**
 * Update chosen properties of all parking objects within trackedParkingsDictionary
 */
+ (void) updateTrackedParkings;

/**
 * Update statuses of all parking objects within parkingsDictionary
 */
+ (void) updateAllStatuses;

/**
 * Set delegate for all parking objects within parkingsDictionary. Should be called once right after callback.
 */
+ (void) setDelegateForAllParkings:(id) newDelegate;

/**
 * RESTKit mapping for Parking object
 */
+ (RKMapping *)mapping;

@end
