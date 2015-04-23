//
//  ViewController.m
//  CocoaPodTest
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    AFHTTPRequestOperation *oper = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = operation.responseString;
        NSLog(@"%@", str);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [oper start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
