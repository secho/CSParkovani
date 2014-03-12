//
//  ParkingObject.h
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface ParkingObject : NSObject


@property(nonatomic, copy) NSNumber *objectId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *addressLine1;
@property(nonatomic, copy) NSString *addressLine2;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *zip;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSNumber *latitude;
@property(nonatomic, copy) NSNumber *longitude;

+ (RKMapping *) mapping;

@end