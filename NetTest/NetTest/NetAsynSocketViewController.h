//
//  NetAsynSocketViewController.h
//  NetTest
//
//  Created by uistrong on 13-3-15.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncSocket;

@interface NetAsynSocketViewController : UIViewController
{
    AsyncSocket *_socket;
    BOOL _isConnecting;
}


- (IBAction) actionHttpGet:(id)sender;
@end
