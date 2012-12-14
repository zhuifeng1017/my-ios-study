//
//  MZViewController.h
//  MyTestAll
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZViewController : UIViewController
{
    CALayer *myLayer;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTest;
- (IBAction)doTableView:(id)sender;
- (IBAction)doMainMenu:(id)sender;
- (IBAction)doTest:(id)sender;
- (IBAction)doPlayAudio:(id)sender;
- (IBAction)doTouch:(id)sender;
- (IBAction)doEnumFile:(id)sender;
- (IBAction)doNotify:(id)sender;
- (IBAction)doRotate:(id)sender;
- (IBAction)doCompass:(id)sender;
@end
