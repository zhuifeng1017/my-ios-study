//
//  MZViewController.m
//  MyTestAll
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZViewController.h"
#import "MZMyView1.h"
#import "MZSettingsViewController.h"
#import "GUMenuItemView.h"
#import "GUMainMenuViewController.h"
#import "MZTouchViewController.h"
#import "MZCompassViewController.h"

#import "QuartzCore/QuartzCore.h"

@interface MZViewController ()
- (void) doBack;
@end

@implementation MZViewController
@synthesize btnTest;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    MZMyView1 *v1 = [[MZMyView1 alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:v1];
    
   // UINib *nib = [UINib nibWithNibName:@"" bundle:nil];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GUMenuItemView" 
                                                 owner:self options:nil];
    for (id obj in nib){
        if ([obj isKindOfClass:[GUMenuItemView class]]){
            GUMenuItemView *myNewView = (GUMenuItemView *)obj;
            myNewView.frame = CGRectMake(10, 200, 60, 80);
            [self.view addSubview:myNewView];
            break;
        }
    }
    
    CALayer *ttLayer = [CALayer layer];
    ttLayer.bounds = CGRectMake(0, 0, 100, 100);
    ttLayer.backgroundColor = [[UIColor colorWithRed:1.0f green:0 blue:0 alpha:1] CGColor];
    //ttLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    ttLayer.position = ttLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
   // ttLayer.position = ttLayer.anchorPoint = CGPointZero;
    [self.view.layer addSublayer:ttLayer];
    NSLog(@"%f,%f,%f,%f", ttLayer.frame.origin.x, ttLayer.frame.origin.y, ttLayer.frame.size.width, ttLayer.frame.size.height);
    
    myLayer = [CALayer layer];
    myLayer.bounds = CGRectMake(0, 0, 100, 100);
    myLayer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor];
    myLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    myLayer.anchorPoint = CGPointMake(1.0f, 1.0f);
    
    [self.view.layer addSublayer:myLayer];
    
    
    for (int i=0; i < 10; i++) {
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"testNotify" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotify:) name:@"testNotify" object:nil];
    }
    
}

- (void)viewDidUnload
{
    [self setBtnTest:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (void) didReceiveMemoryWarning
{
    NSLog(@"MemoryWarning %@", [[self class] description]);
    [super didReceiveMemoryWarning];
    // only want to do this on iOS 6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //  Don't want to rehydrate the view if it's already unloaded
        BOOL isLoaded = [self isViewLoaded];
        
        //  We check the window property to make sure that the view is not visible
        if (isLoaded && self.view.window == nil) {
            
            //  Give a chance to implementors to get model data from their views
            [self performSelectorOnMainThread:@selector(viewWillUnload)
                                   withObject:nil
                                waitUntilDone:YES];
            
            //  Detach it from its parent (in cases of view controller containment)
            [self.view removeFromSuperview];
            self.view = nil;    //  Clear out the view.  Goodbye!
            
            //  The view is now unloaded...now call viewDidUnload
            [self performSelectorOnMainThread:@selector(viewDidUnload)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (void) doBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)doTableView:(id)sender {
    MZSettingsViewController *controller = [[MZSettingsViewController alloc] initWithNibName:@"MZSettingsViewController" bundle:nil];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
   // [self setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:naviController animated:YES];
}

- (IBAction)doMainMenu:(id)sender {
    GUMainMenuViewController *controller = [[GUMainMenuViewController alloc] initWithNibName:@"GUMainMenuViewController" bundle:nil];
    controller.title = @"MainMenu";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:controller action:@selector(doBack)];
    controller.navigationItem.rightBarButtonItem = btnItem;

    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navigationController animated:YES];

}

- (IBAction)doTest:(id)sender {
}

- (IBAction)doPlayAudio:(id)sender {
    
}

- (IBAction)doTouch:(id)sender {
    MZTouchViewController *controller = [[MZTouchViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:controller action:@selector(doBack)];
    controller.navigationItem.rightBarButtonItem = btnItem;
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)doEnumFile:(id)sender {
    
    // 遍历获取gpx文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    
    NSFileManager *fileManager = [NSFileManager defaultManager];  
    NSMutableArray *everyTitle = [[NSMutableArray alloc] init];  
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *filePath = [filePaths objectAtIndex:0];  
    
    NSLog(@"%@",filePath);  
    
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:filePath];  
    
    NSString *fileName;  
    
    while ((fileName = [direnum nextObject])) {  
        
//        if([[fileName pathExtension] isEqualToString:@"pdf"]){  
//            
//            NSArray *strings = [fileName componentsSeparatedByString:@"."];  
//            NSString *fileTitle = [strings objectAtIndex:[strings count]-2];  
//            [everyTitle addObject:fileTitle];  
//        }  
        
        NSLog(@"%@",fileName);  
    }  
    
    
}

- (IBAction)doNotify:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotify" object:nil];
}

- (IBAction)doRotate:(id)sender {
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2880*M_PI/180.0f)];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [myLayer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
    
    //myLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
}

- (IBAction)doCompass:(id)sender {
    MZCompassViewController *controller = [[MZCompassViewController alloc] initWithNibName:@"MZCompassViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(doBack)];
    controller.navigationItem.rightBarButtonItem = btnItem;
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navigationController animated:YES];
}


-(void) testNotify:(NSNotification*) notitfication
{
    if (notitfication != nil) {
        NSLog(@"call testNotify %d", [[notitfication object] intValue]);
    }else {
        NSLog(@"call testNotify");
    }
    
}
@end
