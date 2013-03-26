//
//  SBViewController1.m
//  SBTest
//
//  Created by uistrong on 13-3-26.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "SBViewController1.h"

@interface SBViewController1 ()

@end

@implementation SBViewController1

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

- (IBAction)actionClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
