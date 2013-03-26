//
//  SBRootViewController.m
//  SBTest
//
//  Created by uistrong on 13-3-26.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "SBRootViewController.h"

@interface SBRootViewController ()

@end

@implementation SBRootViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action1:(id)sender{
    NSLog(@"action1 ");
    [self performSegueWithIdentifier:@"push1" sender:nil];
}

- (IBAction)action2:(id)sender{
    NSLog(@"action2 ");
    [self performSegueWithIdentifier:@"modal1" sender:nil];
}

// 重载这个方法，可以实现在页面间传递参数
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue %@:", segue.identifier);
}

@end
