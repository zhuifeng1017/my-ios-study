//
//  NetMyGoUViewController.h
//  NetTest
//
//  Created by uistrong on 13-3-19.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetMyGoUViewController : UIViewController
{
    UIAlertView *_processAlertView;

    NSString *_ipAddr;
    unsigned short _port;
    unsigned long long _token;
}

-(IBAction)actionLogin:(id)sender;

-(IBAction)actionAlive:(id)sender;

-(IBAction)actionUserInfo:(id)sender;

-(IBAction)actionTestXX:(id)sender;
@end
