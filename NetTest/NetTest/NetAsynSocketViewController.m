//
//  NetAsynSocketViewController.m
//  NetTest
//
//  Created by uistrong on 13-3-15.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetAsynSocketViewController.h"

#import "AsyncSocket.h"

@interface NetAsynSocketViewController ()

@end

@implementation NetAsynSocketViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) actionSend:(id)sender{
    if (_socket) {
        static int s_tag = 1;
        NSString *msg = @"how are you?";
        NSData *data = [[NSData alloc] initWithBytes:msg.UTF8String length:strlen(msg.UTF8String)];
        
        int tag = s_tag++;
        [_socket writeData:data withTimeout:6.0 tag:tag];
        [_socket readDataWithTimeout:6.0 tag:tag];
    }
}

- (IBAction) actionConnect:(id)sender{
    _socket = [[AsyncSocket alloc] initWithDelegate:self];
    [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    NSString *HOST = @"192.168.1.101";
    
    NSError *error = nil;
    if (![_socket connectToHost:HOST onPort:8888 withTimeout:3.0 error:&error])
	{
		NSLog(@"Unable to connect to due to invalid configuration: %@", error);
	}else
	{
		NSLog(@"Connecting to %@", HOST);
	}
    
    [self showWait];
}


#pragma mark -- AsyncSocketDelegate method

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddWait];
    });
    NSLog(@"Connect %@ : %d Success", host, port);
    
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (tag == 0) { // 连接成功后第一次接收服务器数据
        NSLog(@"tag : %d ,%@", (int)tag, str);
        [str release];
        [_socket readDataWithTimeout:-1 tag:0];
        
    }else{
        NSLog(@"tag : %d ,%@", (int)tag, str);
        [str release];
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"didReadPartialDataOfLength %d", partialLength);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"onSocketDidDisconnect");
    _socket.delegate = nil;
    [_socket release];
    _socket = nil;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"willDisconnectWithError");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddWait];
    });
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //NSLog(@"didWriteDataWithTag %d", (int)tag);
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length{
    
    NSLog(@"shouldTimeoutReadWithTag %d, elapsed %d", (int)tag, (int)elapsed);
    return  0;
}


@end
