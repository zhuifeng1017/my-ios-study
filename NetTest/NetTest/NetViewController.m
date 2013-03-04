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
#define kUsrInfo_DlType @"dl_type"

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
    NSURL *url = [NSURL URLWithString:@"http://192.168.108.1:8080/WebXX/dl/test.zip"];
    NSString *destPath = [kDocuments stringByAppendingPathComponent:@"test.zip"];
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.zip.temp"];
    
    if ([[self.btnDownload titleForState:UIControlStateNormal] compare:@"下载"] == NSOrderedSame ) {
        _downloadRequest = [ASIHTTPRequest requestWithURL:url];
        
        [_downloadRequest addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
        // 设置用户数据
        [_downloadRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], kUsrInfo_DlType,nil]];
        
        [_downloadRequest setDelegate:self];
        
        [_downloadRequest setTimeOutSeconds:10.0];
        [_downloadRequest setShowAccurateProgress:YES];  // 显示进度
        [_downloadRequest setDownloadProgressDelegate:self]; // 进度代理
        [_downloadRequest setTemporaryFileDownloadPath:tempPath];
        [_downloadRequest setDownloadDestinationPath:destPath];
        
        // 设置支持断点下载
        [_downloadRequest setAllowResumeForFileDownloads:YES];  
        
        [_downloadRequest startAsynchronous]; // 异步

        [self.btnDownload setTitle:@"暂停" forState:UIControlStateNormal];
    }else if ([[self.btnDownload titleForState:UIControlStateNormal] compare:@"暂停"] == NSOrderedSame ){
        [_downloadRequest clearDelegatesAndCancel];
        [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    }
}

- (IBAction)actionDownloadRangeCancel:(id)sender{
    
}

- (IBAction)actionOperation:(id)sender{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
//    [_queue setMaxConcurrentOperationCount:2];
    
    int ID = 0;
    int nCount = 5;
#if 0
    while (nCount--) {
        NetMyOperation *oper = [[[NetMyOperation alloc] init] autorelease];
        oper.operationId = ID++;
        
        if (0) {
            if (ID%2) {
                [oper setQueuePriority:NSOperationQueuePriorityHigh];
            }
            
            if ([_queue operationCount] > 0) {
                NSOperation *beforTask = [[_queue operations] lastObject];
                [oper addDependency:beforTask];
            }
        }
        [_queue addOperation:oper];
    }
#else
    //NSInvocationOperation
    while (nCount--) {
        NSInvocationOperation *oper = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOper:) object:[NSNumber numberWithInt:ID++]] autorelease];
        if (0) {
            if (ID%2) {
                [oper setQueuePriority:NSOperationQueuePriorityHigh];
            }
        }
        [_queue addOperation:oper];
    
        if (1) {
            NSBlockOperation* blockOper = [NSBlockOperation blockOperationWithBlock:^{
                NSLog(@"NSBlockOperation in block: %i", ID);
            }];
            
            [blockOper addExecutionBlock:^{
                NSLog(@"NSBlockOperation addExecutionBlock: %i", ID);
            }];
            
            NSLog(@"NSBlockOperation blocks count : %i, %@", [[blockOper executionBlocks] count], [blockOper executionBlocks]);
            [_queue addOperation:blockOper];
        }
    }
    //ID = 100;
#endif

}

- (void) invocationOper:(id) arg{
    NSLog(@"task %i run … ",[(NSNumber*)arg intValue]);
    [NSThread sleepForTimeInterval:3];
    NSLog(@"task %i is finished. ",[(NSNumber*)arg intValue]);
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

#pragma mark -- ASIHTTPRequestDelegate method

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestFinished");
    NSLog(@"%@", [request responseHeaders]);
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    
    
    id obj = [[request userInfo] objectForKey:kUsrInfo_DlType];
    if (obj != nil) {
        if ([(NSNumber*)obj intValue] == 1) { // 断点下载
            [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
    NSError *error = [request error];
    NSLog(@"%@", error);
    
    id obj = [[request userInfo] objectForKey:kUsrInfo_DlType];
    if (obj != nil) {
        if ([(NSNumber*)obj intValue] == 1) { // 断点下载
            [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
        }
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    id obj = [[request userInfo] objectForKey:kUsrInfo_DlType];
    if (obj != nil) {
        if ([(NSNumber*)obj intValue] == 1) { // 断点下载
            NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
        }
    }
}

#pragma mark -- ASIProgressDelegate method

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    //NSLog(@"didReceiveBytes: %lld", bytes);
    [self.lbl setText:[NSString stringWithFormat:@"%lld", bytes]];
}

- (void)setProgress:(float)newProgress{
     //NSLog(@"newProgress: %f", newProgress);
    [self.progressView setProgress:newProgress];
}

- (void)dealloc {
    [_queue release];
    [_btnDownload release];
    [super dealloc];
}

@end
