//
//  NetAppDelegate.h
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetViewController;
@class BMKMapManager;

@interface NetAppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NetViewController *viewController;

@property (strong, nonatomic) UITabBarController *tabBarViewController;

@end
