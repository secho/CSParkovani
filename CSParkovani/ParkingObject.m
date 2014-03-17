//
//  ParkingObject.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "ParkingObject.h"


@implementation ParkingObject {
    
}

+ (RKObjectMapping *)mapping
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[ParkingObject class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"objectId":@"objectId",
                                                        @"name":@"name",
                                                        @"addressLine1":@"addressLine1",
                                                        @"addressLine2":@"addressLine2",
                                                        @"city":@"city",
                                                        @"zip":@"zip",
                                                        @"country":@"country",
                                                        @"state":@"state",
                                                        @"latitude":@"latitude",
                                                        @"longitude":@"longitude"
                                                        }];
    
    return objectMapping;
}

@end