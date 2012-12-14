//
//  MZTouchViewController.m
//  MyTestAll
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZTouchViewController.h"

@interface MZTouchViewController ()

@end

@implementation MZTouchViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) doBack
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)updateHeadingDisplays:(CGFloat)radians {
    [UIView     animateWithDuration:0.3
                              delay:0.0 
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation;
                             headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, radians);
                             self.view.transform = headingRotation;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
}

- (IBAction)doDD:(id)sender {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:3];
	self.view.transform = CGAffineTransformMakeRotation(-90.0f * M_PI / 180.0);
	[UIView commitAnimations];
}
@end
