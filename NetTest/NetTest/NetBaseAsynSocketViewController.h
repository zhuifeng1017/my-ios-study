//
//  NetBaseAsynSocketViewController.h
//  NetTest
//
//  Created by uistrong on 13-4-16.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetBaseAsynSocketViewController : UIViewController
{
    UIAlertView *_processAlertView;
}
- (IBAction) actionSend:(id)sender;
- (IBAction) actionConnect:(id)sender;

- (void) showWait;
- (void) hiddWait;

@end
