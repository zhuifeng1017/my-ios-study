//
//  MZAppDelegate.m
//  MyTestAll
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZAppDelegate.h"

#import "MZViewController.h"
#import "MZTestMiniZipViewController.h"
#import "MZGetPhotoViewController.h"
#import "MZNewsViewController.h"
#import "MZVoiceViewController.h"


@interface MZOBJ : NSObject

@property (strong, nonatomic) NSString *str;
@property (assign, nonatomic) int n;
- (void) mzDescription;
@end

@implementation MZOBJ
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) mzDescription
{
   NSLog(@"%@ , %d ", self.str , self.n);
}
@end

@implementation MZAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    NSLog(@"NSTemporaryDirectory : %@" , NSTemporaryDirectory());


    NSLog(@"xxxx: %d",  [[NSTimeZone localTimeZone] secondsFromGMT]);
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strNow = [DateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", strNow);
    
//
//    NSString *str = @"   ,sdsd,sdaf 223, sd,";
//    NSArray *arr = [str componentsSeparatedByString:@","];
//    NSLog(@"%d, %@",[arr count], [arr description]);


   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Ove/Applications/Photo Booth.apprride point for customization after application launch.
    
#if 0
    self.viewController = [[MZViewController alloc] initWithNibName:@"MZViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    //
    self.viewController = [[MZTestMiniZipViewController alloc] initWithNibName:@"MZTestMiniZipViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    self.viewController = [[MZGetPhotoViewController alloc] initWithNibName:@"MZGetPhotoViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
#else
    self.tabBarViewController = [[UITabBarController alloc] init];
    
    MZViewController *controller1 = [[MZViewController alloc] initWithNibName:@"MZViewController" bundle:nil];
    MZGetPhotoViewController *controller2 = [[MZGetPhotoViewController alloc] initWithNibName:@"MZGetPhotoViewController" bundle:nil];
   // MZNewsViewController *controller3 = [[MZNewsViewController alloc] initWithNibName:@"MZNewsViewController" bundle:nil];
    MZVoiceViewController *controller4 = [[MZVoiceViewController alloc] initWithNibName:@"MZVoiceViewController" bundle:nil];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"新闻" image:[UIImage imageNamed:@"second.png"] tag:0];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"话题" image:[UIImage imageNamed:@"second.png"] tag:1];
   // controller3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其他" image:[UIImage imageNamed:@"second.png"] tag:1];
    controller4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其他" image:[UIImage imageNamed:@"second.png"] tag:1];
    self.tabBarViewController.viewControllers = [NSArray arrayWithObjects:controller1, controller2, controller4, nil];
    self.window.rootViewController = self.tabBarViewController;
#endif
    
    
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
