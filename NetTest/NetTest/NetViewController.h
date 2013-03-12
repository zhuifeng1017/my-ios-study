//
//  NetViewController.h
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"


@interface NetViewController : UIViewController <ASIHTTPRequestDelegate, ASIProgressDelegate>
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

- (IBAction)actionSocket:(id)sender;

- (IBAction)actionOperation:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btnDownload;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain, nonatomic) IBOutlet UILabel *lbl;
@end
