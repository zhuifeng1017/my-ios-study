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
{
    ASIHTTPRequest *_downloadRequest;
    NSOperationQueue *_queue;
}

- (IBAction)actionGet:(id)sender;
- (IBAction)actionAsynGet:(id)sender;
- (IBAction)acitonAsynBlockGet:(id)sender;
- (IBAction)actionDownload:(id)sender;
- (IBAction)actionDownloadRange:(id)sender;
- (IBAction)actionDownloadRangeCancel:(id)sender;

- (IBAction)actionOperation:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btnDownload;

@end
