//
//  NetViewController.h
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface NetViewController : UIViewController <ASIHTTPRequestDelegate>


- (IBAction)actionGet:(id)sender;
- (IBAction)actionAsynGet:(id)sender;
- (IBAction)acitonAsynBlockGet:(id)sender;
@end
