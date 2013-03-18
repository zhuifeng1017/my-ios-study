//
//  NetRunLoopViewController.h
//  NetTest
//
//  Created by uistrong on 13-3-14.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetRunLoopViewController : UIViewController <NSStreamDelegate>{
    BOOL _running;
    
    NSMutableData* _data;
    unsigned _bytesRead;
}

- (IBAction)actionRunLoop:(id)sender;
- (IBAction)actionRunLoop2:(id)sender;
- (IBAction)actionRunLoop3:(id)sender;
- (IBAction)actionRunLoopStop:(id)sender;

- (IBAction)actionAlert:(id)sender;

- (IBAction)actionThread:(id)sender;

- (IBAction)actionStream:(id)sender;
@end
