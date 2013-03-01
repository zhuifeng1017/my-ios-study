//
//  NetAppDelegate.m
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetAppDelegate.h"

#import "NetViewController.h"

@implementation NetAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabBarViewController = [[UITabBarController alloc] init];
    
    // Override point for customization after application launch.
    NetViewController *controller1 = [[[NetViewController alloc] initWithNibName:@"NetViewController" bundle:nil] autorelease];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"second.png"] tag:0];
    
    NetViewController *controller2 = [[[NetViewController alloc] initWithNibName:@"NetViewController" bundle:nil] autorelease];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"队列" image:[UIImage imageNamed:@"second.png"] tag:2];
    
    self.tabBarViewController.viewControllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    self.window.rootViewController = self.tabBarViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
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
