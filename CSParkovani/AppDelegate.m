//
//  AppDelegate.m
//  CSParkovani
//
//  Created by Jan Sechovec on 11.03.14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit.h>
#import "LocationService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    [self initObjectManager];
    [[LocationService sharedInstance] startUpdating];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LocationService sharedInstance] stopUpdating];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LocationService sharedInstance] stopUpdating];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LocationService sharedInstance] startUpdating];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LocationService sharedInstance] startUpdating];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LocationService sharedInstance] stopUpdating];
}

- (void)initObjectManager
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://www.csast.csas.cz/ie_mbe/rest/v1/parking/"]];
    [manager setAcceptHeaderWithMIMEType:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"];
}

@end