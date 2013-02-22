//
//  MZViewController.m
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import "MZViewController.h"

@interface MZViewController ()

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    NSLog(@"MZViewController dealloc");
    [super dealloc];
}

- (IBAction)actionThread:(id)sender {
    if (_thrProducer == nil) {
        _thrProducer = [[NSThread alloc] initWithTarget:self selector:@selector(producerThread:) object:self];
    }
    if (![_thrProducer isExecuting]) {
        _thrProducerRunning = YES;
        [_thrProducer start];
    }
}

- (IBAction)actionThreadStop:(id)sender {
    
    if (_thrProducer) {
        if ([_thrProducer isExecuting]) {
            _thrProducerRunning = NO;
            int nCount = 1000;
            while (![_thrProducer isFinished] && nCount--) {
                usleep(1000);
            }
            
            if (!nCount) {
                [NSThread exit];
            }
        }
        
        [_thrProducer release];
        _thrProducer = nil;
        
        NSLog(@"thread is stop");
    }else{
       NSLog(@"thread is not create"); 
    }
}

- (void) producerThread:(id) param{
    static int i = 0;
    while (_thrProducerRunning) {
        NSLog(@"%d", i++);
        sleep(1);
    }
}
@end
