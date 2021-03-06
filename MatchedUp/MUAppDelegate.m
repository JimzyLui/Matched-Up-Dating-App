//
//  MUAppDelegate.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/7/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUAppDelegate.h"

@implementation MUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"z9XpRS4BcDHdssl32xEUx0sMjDDwWBSgiM8Xof69"
                  clientKey:@"NqHtcYlXeEuPBDO5WUEtr1rrw1OfDD6jNHsgCAR6"];
    [PFFacebookUtils initializeFacebook];

    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];

    NSString *defaultPrefsFile = [[NSBundle mainBundle]
                                  pathForResource:@"defaultPrefsFile" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary
                                        dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];

    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
            @{NSForegroundColorAttributeName : [UIColor colorWithRed:12/255.0 green:158/255.0 blue:255/255.0 alpha:1.0],
                         NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]}];

    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [PFFacebookUtils handleOpenURL:url];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
