//
//  NetViewController.m
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetViewController.h"
#import "ASIHTTPRequest.h"
#import "NetMyOperation.h"

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kCatches [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]

@interface NetViewController ()

@end

@implementation NetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionGet:(id)sender{
    [self get:0];
}

- (IBAction)actionAsynGet:(id)sender{
    [self get:1];
}

- (IBAction)acitonAsynBlockGet:(id)sender{
    [self get:2];
}

- (IBAction)actionDownload:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://192.168.108.1:8080/WebXX/test.zip"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
    NSString *destPath = [kDocuments stringByAppendingPathComponent:@"test.zip"];
    [request setDownloadDestinationPath:destPath];
    [request setTimeOutSeconds:3.0];
    [request startSynchronous]; // 同步
    NSError *error = [request error];
    if (error) {
        NSLog(@"%@", error);
    }else{
        // 检查文件是否存在
        NSLog(@"download success!");
    }
}

- (IBAction)actionDownloadRange:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://192.168.108.1:8080/WebXX/dl/xx.zip"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
    NSString *destPath = [kDocuments stringByAppendingPathComponent:@"xx.zip"];
    [request setTimeOutSeconds:3.0];
    [request setShowAccurateProgress:YES];

    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_xx.zip"];
    [request setTemporaryFileDownloadPath:tempPath];
    [request setDownloadDestinationPath:destPath];
    [request setAllowCompressedResponse:YES];
    
   [request startAsynchronous]; // 异步
}

- (IBAction)actionDownloadRangeCancel:(id)sender{
    
}

- (IBAction)actionOperation:(id)sender{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    NetMyOperation *oper = [[[NetMyOperation alloc] init] autorelease];
    int ID = 0;
    oper.operationId = ID++;
    [_queue addOperation:oper];
    
}

- (void) get:(int) type{
    NSURL *url = [NSURL URLWithString:@"http://192.168.108.1:8080/WebXX"];
    if (type == 0) {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
        
        [request setTimeOutSeconds:3.0];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSLog(@"%@",  [request requestMethod]);
            NSLog(@"%@", [request requestHeaders]);
            NSString *response = [request responseString];
            NSLog(@"%@", response);
        }else{
            NSLog(@"%@", error);
        }
    }else if (type == 1){
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
        
        [request setDelegate:self];
        [request setTimeOutSeconds:3.0];
        [request startAsynchronous];
    }else{
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString ---:  %@", responseString);
            // Use when fetching binary data
            //NSData *responseData = [request responseData];
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"error ---:  %@", error);
        }];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestFinished");
    NSLog(@"%@", [request responseHeaders]);
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)dealloc {
    [_btnDownload release];
    [super dealloc];
}
@end
