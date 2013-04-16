//
//  NetAsynSocketViewController.h
//  NetTest
//
//  Created by uistrong on 13-3-15.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetBaseAsynSocketViewController.h"

@class AsyncSocket;


@interface NetAsynSocketViewController : NetBaseAsynSocketViewController
{
    AsyncSocket *_socket;    
    UIAlertView *_processAlertView;
}

- (IBAction) actionHttpGet:(id)sender;
- (IBAction) actionConnect:(id)sender;



@end
