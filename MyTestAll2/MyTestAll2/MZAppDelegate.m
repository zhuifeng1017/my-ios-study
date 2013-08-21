//
//  MZAppDelegate.m
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import "MZAppDelegate.h"

#import "MZViewController.h"
#import "MZPerson.h"
@implementation MZAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (time_t) gmTime{
    time_t timep;
    time(&timep);
    struct tm *pTime = gmtime(&timep);
    timep = mktime(pTime);
    return (time_t)timep;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if 1
    char str[] = {'a','b', 0x0};
    NSString *objStr = [NSString stringWithUTF8String:str];
    NSArray *arr = [NSArray arrayWithObject:objStr]; // remember: NSArray hold elements only reference, not copy!!!
    objStr = @"asd"; // this operate cause the objStr point a new object!!!
    NSLog(@"arr[0]: %@,  objStr: %@, %d", arr[0], objStr, [objStr retainCount]);
    
//
    MZPerson *person = [[MZPerson alloc] init];
    person.name = @"xx";
    NSArray *arr2 = [NSArray arrayWithObject:person] ;
    [(MZPerson*)arr2[0] setName:@"zz"];
    NSLog(@"arr[0]: %@,  name: %@", [(MZPerson*)arr2[0] name], person.name);
    [person release];
    
#endif
    


    double lon = (double)12140856 /100000;
    double lat = (double)3114761 /100000;
    NSLog(@"%f, %f", lon, lat);
    
#if 0   //测试时间
    time_t timep;
    struct tm *p;
    time(&timep); /*当前time_t类型UTC时间*/
    NSLog(@"time(&timep): %ld, gmTime : %lld",(long)timep, [self gmTime]);
    
    p = gmtime(&timep); /*得到tm结构的UTC时间*/
    
    timep = mktime(p); /*转换，这里会有时区的转换*/
    NSLog(@"time()->gmtime()->mktime(): %ld, timegm: %ld", (long)timep, (long)timegm(p));
    
    return 0;
#endif
    
    
#if 0 // 测试时间
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    
    NSLog(@"%@, %d, %f", destinationDate, sourceGMTOffset, interval);
#endif
    
    
//    MZPerson *person = [[MZPerson alloc] init];
//    NSString *strName = @"abc";
//    person.name = strName;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    MZViewController *VC = [[MZViewController alloc] initWithNibName:@"MZViewController" bundle:nil];
    self.viewController = VC;
    [VC release];

    self.window.rootViewController = self.viewController;
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
