//
//  PredictionValue.m
//  CSParkovani
//
//  Created by Jan Sechovec on 12.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "PredictionValue.h"
#import <RestKit.h>


@implementation PredictionValue {
    
}

+ (RKObjectMapping *) mapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[PredictionValue class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"parkingFK":@"parkingFK",
                                                        @"time":@"time",
                                                        @"weekDay":@"weekDay",
                                                        @"count":@"count",
                                                        @"yes":@"yes",
                                                        @"median":@"median",
                                                        @"average":@"average"
                                                        }];
    
    return objectMapping;
}

- (void)updatePrediction:(void (^)(PredictionValue *))result onFault:(void (^)(NSError *))fault {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[PredictionValue mapping]
                                                method:RKRequestMethodAny
                                                pathPattern:nil
                                                keyPath:@""
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    //    [[RKObjectManager sharedManager] getObjectsAtPath:<#(NSString *)path#> parameters:<#(NSDictionary *)parameters#> success:<#(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success#> failure:<#(void (^)(RKObjectRequestOperation *operation, NSError *error))failure#>];
    
}

@end