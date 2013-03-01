//
//  NetMyOperation.m
//  NetTest
//
//  Created by uistrong on 13-3-1.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetMyOperation.h"

@implementation NetMyOperation
@synthesize operationId;

- (void)main{
    NSLog(@"task %i run … ",operationId);
    [NSThread sleepForTimeInterval:3];
    NSLog(@"task %i is finished. ",operationId);
}

@end
