//
//  NetRunLoopViewController.m
//  NetTest
//
//  Created by uistrong on 13-3-14.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetRunLoopViewController.h"

@interface NetRunLoopViewController ()

@end

@implementation NetRunLoopViewController

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

- (IBAction)actionRunLoop:(id)sender{
   NSLog(@"runMode: %@", [[NSDate date] description]);
    // 一旦有事件函数马上返回
   [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
   NSLog(@"runMode: %@", [[NSDate date] description]);
}


- (IBAction)actionRunLoop2:(id)sender{
    NSLog(@"runUntilDate: %@", [[NSDate date] description]);
    //还可以处理屏幕事件，单直到时间到了函数才返回
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:15]];
    NSLog(@"runUntilDate: %@", [[NSDate date] description]);
        
}

- (IBAction)actionRunLoop3:(id)sender{
    NSLog(@"CFRunLoopRun: %@", [[NSDate date] description]);
    CFRunLoopRun();
    NSLog(@"CFRunLoopRun: %@", [[NSDate date] description]);
}

- (IBAction)actionRunLoopStop:(id)sender{
    //CFRunLoopStop(CFRunLoopGetCurrent());
   // CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
}

- (IBAction)actionAlert:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"AAA" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)actionThread:(id)sender{
    _running = YES;
   [NSThread detachNewThreadSelector:@selector(run1:) toTarget:self withObject:nil];
    while (_running) {
        NSLog(@"runloop…");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode  beforeDate:[NSDate distantFuture]];
        NSLog(@"runloop end…");
    }
}

- (void) run1:(id) obj{
    int n = 3;
    while (n--) {
        NSLog(@"run%d...", n);
        sleep(1);
    }
    // 发送事件给主线程，让runloop立即返回
    [self performSelectorOnMainThread:@selector(setRunning:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
    
#if 0 // 也可以用dispatch_async来代替上面的代码
    _running = NO;
    dispatch_async(dispatch_get_main_queue(), ^{} );
#endif
    
}

- (void) setRunning:(NSNumber*) obj{
    _running = [obj boolValue];
}


- (IBAction)actionStream:(id)sender{
    //读取文件
    NSString *dstFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.zip"];
    NSInputStream *istream = [NSInputStream inputStreamWithFileAtPath:dstFile];
    [istream setDelegate:self];
    NSLog(@"actionStream 0");
    [istream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [istream open];
    
    NSLog(@"actionStream 1");
}

#pragma mark -- NSStreamDelegate method
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode{
    switch((NSUInteger)eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            if(!_data) {
                _data = [[NSMutableData data] retain];
            }
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            if(len) {
                [_data appendBytes:(const  void *)buf length:len];
                _bytesRead += len;
            } else {
                NSLog(@"no buffer!");
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        case NSStreamEventEndEncountered:
        {
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            // 打印
            NSLog(@"%x", (char*)_data.bytes);
            break;
        
        }
    }
}

@end
