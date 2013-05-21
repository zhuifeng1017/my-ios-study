//
//  NetGCDAsynSocketViewController.m
//  NetTest
//
//  Created by uistrong on 13-4-16.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetGCDAsynSocketViewController.h"
#import "GCDAsyncSocket.h"


@interface NetGCDAsynSocketViewController ()

@end

@implementation NetGCDAsynSocketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) actionSend:(id)sender{
    // 发送数据
    if (gcdSocket) {
        static int s_tag = 1;
        NSString *msg = @"how are you?";
        NSData *data = [[NSData alloc] initWithBytes:msg.UTF8String length:strlen(msg.UTF8String)];
        
        int tag = s_tag++;
        [gcdSocket writeData:data withTimeout:10.0 tag:tag];
        //[gcdSocket readDataWithTimeout:10.0 tag:tag];
    }
}

- (IBAction) actionConnect:(id)sender{
    if (gcdSocket == nil) {
        gcdSocket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSString *HOST = @"192.168.1.101";
        
        NSError *error = nil;
        if (![gcdSocket connectToHost:HOST onPort:8888 withTimeout:3.0 error:&error])
        {
            NSLog(@"Unable to connect to due to invalid configuration: %@", error);
        }else
        {
            NSLog(@"Connecting to %@", HOST);
        }
        
        [self showWait];
    }
}

- (void) onConnected{
    [self hiddWait];
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void) onDisConnected{
    [self hiddWait];
    [_timer invalidate];
    _timer = nil;
}

- (void) keepAlive{
    if (gcdSocket) {
        NSString *msg = @"这是心跳包";
        NSData *data = [[NSData alloc] initWithBytes:msg.UTF8String length:strlen(msg.UTF8String)];
        [gcdSocket writeData:data withTimeout:10.0 tag:0];
    }
}

#pragma mark -- GCDAsyncSocketDelegate method
/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self connectSuccess];
//    });
    [self onConnected];
    
    NSLog(@"Connect %@ : %d Success", host, port);
    
    [gcdSocket readDataWithTimeout:-1 tag:0];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    struct t_header{
        int ID;
        int length;
    };
 
#define USE_MARK_MM 0
    
    if (tag == 0) { // 连接成功后，接收服务端数据
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"tag : %d ,%@", (int)tag, str);
        [str release];
        
        //循环等待接收: 先接收头，再接收数据
        // 或者: 每接收一次后，由上层解析解决粘包问题。
        
#if USE_MARK_MM // 按标记符接收
        NSData *markData = [NSData dataWithBytes:"\r\n" length:strlen("\r\n")];
        [gcdSocket readDataToData:markData withTimeout:-1 tag:1];
        
#else // 按长度接收
        
        int nHeaderSize = sizeof(struct t_header);
        [gcdSocket readDataToLength:nHeaderSize withTimeout:-1 tag:1];
#endif
        
    }else if (tag == 1){ // 头
        
#if USE_MARK_MM        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"tag : %d ,%@", (int)tag, str);
        [str release];
        // 判断是否有数据需要接收
        // 接收数据，超时时间指定为10s
        [gcdSocket readDataWithTimeout:10 tag:2]; 
#else
        // 打印头
        const struct t_header *pHeader = (const struct t_header*)[data bytes];
        NSLog(@"header info - ID:%d, length:%d", pHeader->ID, pHeader->length);
        if (pHeader->length) {
            [gcdSocket readDataToLength:pHeader->length withTimeout:10 tag:2]; // 如果这一步超时了怎么办？ 断开连接重连？？？
        }else{ // 没有数据，则直接进入下一次循环接收
            int nHeaderSize = sizeof(struct t_header);
            [gcdSocket readDataToLength:nHeaderSize withTimeout:-1 tag:1];
        }
#endif


    }else if (tag == 2){ // 数据
        // 打印数据部分
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"tag : %d ,%@", (int)tag, str);
        [str release];
        
        // 一个交互完成后，则直接进入下一次循环接收
#if USE_MARK_MM // 按标记符接收
        NSData *markData = [NSData dataWithBytes:"\r\n" length:strlen("\r\n")];
        [gcdSocket readDataToData:markData withTimeout:-1 tag:1];
#else // 按长度接收
        int nHeaderSize = sizeof(struct t_header);
        [gcdSocket readDataToLength:nHeaderSize withTimeout:-1 tag:1];
#endif
        
    }
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{  
//}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    NSLog(@"TimeoutReadWithTag :%d , elapsed %d", (int)tag, (int)elapsed);
    return 0;
}


//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length;



/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socketDidDisconnect, %@", err);
    
    [gcdSocket setDelegate:nil];
    gcdSocket = nil;
    
    [self onDisConnected];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self hiddWait];
//    });
}



@end
