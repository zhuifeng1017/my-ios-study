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


- (IBAction) actionHttpGet:(id)sender{
    
    if (_socket == nil) {
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }else{
        [_socket disconnect];
    }
    
    _isConnecting = YES;
    NSError *err;
    [_socket connectToHost:@"www.baidu.com" onPort:80 withTimeout:6.0 error:&err];
    while (_isConnecting) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    if (![_socket isConnected]) {
        NSLog(@"connect timeout");
        [_socket release];
        _socket = nil;
        return;
    }
    
    // 发送数据
    [_socket readDataWithTimeout:3.0 tag:0];
    char *strRequest = "GET / HTTP/1.0\r\n\r\n";
    NSData *data = [[NSData alloc] initWithBytes:strRequest length:strlen(strRequest)];
    [_socket writeData:data withTimeout:3.0 tag:0];
}


#pragma mark -- AsyncSocketDelegate method

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
     NSLog(@"didConnectToHost success");
    _isConnecting = NO;
    dispatch_async(dispatch_get_main_queue(), ^{});
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    [str release];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"didReadPartialDataOfLength %d", partialLength);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"onSocketDidDisconnect");
    [sock release];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    _isConnecting = NO;
    dispatch_async(dispatch_get_main_queue(), ^{});
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}


@end
