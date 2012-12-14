//
//  MZNewsViewController.m
//  MyTestAll
//
//  Created by uistrong on 12-11-28.
//
//

#import "MZNewsViewController.h"

@interface MZNewsViewController ()

@end

@implementation MZNewsViewController

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
//            [self performSelectorOnMainThread:@selector(viewDidUnload)
//                                   withObject:nil
//                                waitUntilDone:YES];
            [self viewDidUnload];
        }
    }
}


- (void) viewDidUnload
{
    [super viewDidUnload];
}
@end
