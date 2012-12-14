//
//  MZCompassViewController.m
//  MyTestAll
//
//  Created by  on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZCompassViewController.h"

@interface MZCompassViewController ()

@end

@implementation MZCompassViewController
@synthesize compassView;

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
    [MZLocation shareInstance].delegate = self;
    [[MZLocation shareInstance] startUpdatingLocation];
    [[MZLocation shareInstance] startUpdatingHeading];
    
    //_timer =[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];

}

- (void) refresh
{
    NSLog(@" NSTimer refresh" );
}

- (void)viewDidUnload
{
    [self setCompassView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updatingLocation:(CLLocation *)newLocation
{
    NSLog(@"%@", newLocation.description);

}

- (void)UpdatingHeading:(CLHeading *)newHeading
{
    NSLog(@"%@", newHeading.description);
    if ((int)newHeading.trueHeading >= 0) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3f];
//        self.compassView.transform = CGAffineTransformMakeRotation(newHeading.trueHeading*M_PI/180.0);
//        [UIView commitAnimations];
        
        // trueHeading 表手机头与地理北的夹角，手机头为0， 夹角为 0 - trueHeading
        CGFloat radians = -newHeading.trueHeading*M_PI/180.0; 
        [UIView  animateWithDuration:0.3
                                  delay:0.0 
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 CGAffineTransform headingRotation;
                                 headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, radians);
                                 self.compassView.transform = headingRotation;
                             }
                             completion:^(BOOL finished) {}];
    }
}
@end
