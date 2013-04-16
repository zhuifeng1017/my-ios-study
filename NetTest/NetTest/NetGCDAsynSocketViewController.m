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

- (IBAction) actionHttpGet:(id)sender{
    // 发送数据
    if (gcdSocket) {
        
        NSData *httpMark = [NSData dataWithBytes:"\r\n\r\n" length:4];
        [gcdSocket readDataToData:httpMark withTimeout:10.0 tag:0];
        
        char *strRequest = "GET / HTTP/1.0\r\n\r\n";
        NSData *data = [[NSData alloc] initWithBytes:strRequest length:strlen(strRequest)];
        
        [gcdSocket writeData:data withTimeout:3.0 tag:0];
    }
}

- (IBAction) actionConnect:(id)sender{
    if (gcdSocket == nil) {
        gcdSocket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    NSError *error = nil;
    if (![gcdSocket connectToHost:@"www.baidu.com" onPort:80 error:&error])
	{
		NSLog(@"Unable to connect to due to invalid configuration: %@", error);
	}else
	{
		NSLog(@"Connecting to baidu.com");
	}
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connect baidu.com Success");
    
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"tag : %d", (int)tag);
    NSLog(@"%@", str);
    [str release];
    [gcdSocket readDataWithTimeout:10 tag:1];
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
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length;


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
    NSLog(@"socketDidDisconnect!");
    [gcdSocket setDelegate:nil];
    gcdSocket = nil;
}



@end
