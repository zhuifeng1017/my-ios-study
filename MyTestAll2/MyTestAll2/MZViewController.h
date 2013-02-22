//
//  MZViewController.h
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZViewController : UIViewController
{
    NSThread *_thrProducer;
    BOOL _thrProducerRunning;
}
- (IBAction)actionThread:(id)sender;
- (IBAction) actionThreadStop:(id)sender;
@end
