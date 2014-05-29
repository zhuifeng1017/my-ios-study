//
//  SBTabViewController.m
//  SBTest
//
//  Created by uistrong on 14-5-29.
//  Copyright (c) 2014年 uistrong. All rights reserved.
//

#import "SBTabViewController.h"
#import "SBRootViewController.h"

@interface SBTabViewController ()

@end

@implementation SBTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIViewController *controller1 = [[UIViewController alloc] init];
    UIViewController *controller2 = [[UIViewController alloc] init];
    UIViewController *controller3 = [[UIViewController alloc] init];
    UIViewController *controller4 = [[UIViewController alloc] init];
   // UIViewController *controller5 = [[UIViewController alloc] init];
    
//    SBRootViewController *controller5 = [[SBRootViewController alloc] init];
    
//    MainStoryboard.storyboard
    UIStoryboard *stroryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SBRootViewController *controller5 = [stroryboard instantiateViewControllerWithIdentifier:@"SBRootViewController"];
    
    
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"second.png"] tag:0];
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"类别" image:[UIImage imageNamed:@"second.png"] tag:1];
    controller3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"排行" image:[UIImage imageNamed:@"second.png"] tag:2];
    controller4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"second.png"] tag:3];
    controller5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"second.png"] tag:4];
    
    self.viewControllers = [NSArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
