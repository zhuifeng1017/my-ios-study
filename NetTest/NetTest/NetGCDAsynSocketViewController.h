//
//  NetGCDAsynSocketViewController.h
//  NetTest
//
//  Created by uistrong on 13-4-16.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetBaseAsynSocketViewController.h"

@class GCDAsyncSocket;

@interface NetGCDAsynSocketViewController : NetBaseAsynSocketViewController
{
    GCDAsyncSocket *gcdSocket;
}
- (IBAction) actionHttpGet:(id)sender;
- (IBAction) actionConnect:(id)sender;

@end
