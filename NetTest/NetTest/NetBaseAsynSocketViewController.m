//
//  NetBaseAsynSocketViewController.m
//  NetTest
//
//  Created by uistrong on 13-4-16.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetBaseAsynSocketViewController.h"

@interface NetBaseAsynSocketViewController ()

@end

@implementation NetBaseAsynSocketViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showWait{
    if (_processAlertView == nil) {
        _processAlertView = [[UIAlertView alloc]
                             initWithTitle:@"正在连接..."
                             message:nil
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
        UIActivityIndicatorView *Activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 65, 20, 20)];
        [Activity startAnimating];
        [_processAlertView addSubview:Activity];
    }
    [_processAlertView show];
}

- (void) hiddWait{
    if (_processAlertView != nil) {
        [_processAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end
