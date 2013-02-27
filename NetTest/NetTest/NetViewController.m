//
//  NetViewController.m
//  NetTest
//
//  Created by uistrong on 13-2-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetViewController.h"
#import "ASIHTTPRequest.h"

@interface NetViewController ()

@end

@implementation NetViewController

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


- (IBAction)actionGet:(id)sender{
    [self get:0];
}

- (IBAction)actionAsynGet:(id)sender{
    [self get:1];
}

- (IBAction)acitonAsynBlockGet:(id)sender{
    [self get:2];
}

- (void) get:(int) type{
    NSURL *url = [NSURL URLWithString:@"http://192.168.108.1:8080/WebXX"];
    if (type == 0) {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request addRequestHeader:@"User-Agent" value:@"ipod touch; min's ipod; zh_CN"];
        
        [request setTimeOutSeconds:3.0];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSLog(@"%@",  [request requestMethod]);
            NSLog(@"%@", [request requestHeaders]);
            NSString *response = [request responseString];
            NSLog(@"%@", response);
        }
    
    }else if (type == 1){
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
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
    
    [request release];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
    NSError *error = [request error];
    NSLog(@"%@", error);
    
    [request release];
}

@end
