//
//  LocationService.m
//  CSParkovani
//
//  Created by Viktor Smidl on 17/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "LocationService.h"

@interface LocationService () <CLLocationManagerDelegate>
{
    CLLocation *_lastLocation;
    CLLocationManager *_locationManager;
}
@end

@implementation LocationService

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedObject;
    
    dispatch_once(&once, ^{
        
        sharedObject = [[self alloc] init];
        
    });
    
    return sharedObject;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = 100.;
        _locationManager.distanceFilter = 10.;
    }
    
    return self;
}

- (void)startUpdating
{
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdating
{
    [_locationManager stopUpdatingLocation];
}

- (CLLocation *)lastKnownLocation
{
    return _lastLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _lastLocation = [locations lastObject];
}


- (void)asyncGetRouteDirectionByCarToLocation:(CLLocationCoordinate2D)toLocation completition:(void (^)(NSTimeInterval, NSError *))completitionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getRouteDirectionFromLocation:[self lastKnownLocation].coordinate toLocation:toLocation completition:completitionBlock];
        
    });
}

- (void)getRouteDirectionFromLocation:(CLLocationCoordinate2D)origin toLocation:(CLLocationCoordinate2D)destination completition:(void (^)(NSTimeInterval, NSError *))completitionBlock
{
    const NSTimeInterval defaultDuration = CGFLOAT_MIN;
    
    NSError *error;
    NSTimeInterval duration = defaultDuration;
    NSData *data;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?sensor=false&origins=%f,%f&destinations=%f,%f&mode=driving", origin.latitude, origin.longitude, destination.latitude, destination.longitude]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSURLResponse *response;
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data && !error)
    {
        //NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (parsedResponse && !error)
        {
            NSDictionary *tmpDictionary;
            NSArray *tmpArray;
            NSString *tmpString;
            NSNumber *tmpNumber;
            
            //get response rows
            tmpArray = [parsedResponse objectForKey:@"rows"];
            
            if (tmpArray.count > 0)
            {
                //get first row
                tmpDictionary = tmpArray[0];
                
                //get first row elements
                tmpArray = [tmpDictionary objectForKey:@"elements"];
                
                if (tmpArray.count > 0)
                {
                    //get first row first element
                    tmpDictionary = tmpArray[0];
                    
                    //get status string of first element
                    tmpString = [tmpDictionary objectForKey:@"status"];
                    
                    if ([tmpString isEqualToString:@"OK"])
                    {
                        //get duration object of first element
                        tmpDictionary = [tmpDictionary objectForKey:@"duration"];
                        
                        //get value of duration
                        tmpNumber = [tmpDictionary objectForKey:@"value"];
                        
                        
                        duration = tmpNumber.doubleValue;
                    }
                }
            }
        }
    }
    
    if (!error && duration == defaultDuration)
    {
        error = [NSError errorWithDomain:@"cz.csas.parking" code:100 userInfo:@{NSLocalizedDescriptionKey:@"google maps api: invalid response structure"}];
    }
    
    if (completitionBlock) completitionBlock(duration, error);
}

@end
