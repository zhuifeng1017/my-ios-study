//
//  MZAppDelegate.h
//  MyTestAll
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZViewController;

@interface MZAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UITabBarController *tabBarViewController;
@end




