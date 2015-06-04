//
//  ViewController.m
//  CocoaPodTest
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sdImage sd_setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/bdlogo.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)afnBtnClick:(id)sender {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    AFHTTPRequestOperation *oper = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = operation.responseString;
        NSLog(@"%@", str);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    [oper start];
}

@end
