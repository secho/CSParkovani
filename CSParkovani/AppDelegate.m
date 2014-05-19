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
#define VERSION @"1.0"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor blueColor];
//    [self.window makeKeyAndVisible];

    [[self window] setBackgroundColor:[UIColor whiteColor]];

    [self initObjectManager];
    [[LocationService sharedInstance] startUpdating];

    /*  get current application version from remote plist
    *   if remote version from plist is other, show update dialog*/



    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://www.csas.cz/html/ios/CSParkovani.plist"]];
    NSDictionary *items = [dict valueForKey:@"items"];
    NSDictionary *metadata = [items valueForKey:@"metadata"];
    NSArray *bundleVersion = [metadata valueForKey:@"bundle-version"];
    NSString *remoteVersion = [bundleVersion objectAtIndex:0];

    if ([remoteVersion isEqualToString:VERSION] || !remoteVersion) {
        NSLog(@"APP Version: shodne verze");
    } else {
        NSLog(@"APP Version: NALEZENA ROZDILNA VERZE");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Nová verze"
                                                            message:@"Je k dispozici nová verze aplikace. Přejete si přejít na stránku s aktualizací?"
                                                           delegate:self cancelButtonTitle:@"Teď ne!"
                                                  otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Aktualizovat"];
        [alertView show];
    }

    NSLog(@"APP Version: %@", remoteVersion);

    return YES;
}
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     if (buttonIndex == 1) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.csas.cz/html/parkovani/update.html"]];
     }
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
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://www.csas.cz/ie_mbe/rest/v1/parking/"]];
    [manager setAcceptHeaderWithMIMEType:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"];
}

@end