//
//  SBViewController2.m
//  SBTest
//
//  Created by uistrong on 13-3-26.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "SBViewController2.h"

@interface SBViewController2 ()

@end

@implementation SBViewController2

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
    self.title = @"这是使用xib";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    NSLog(@"SBViewController2 dealloc");
    [super dealloc];
}

@end
