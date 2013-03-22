//
//  NetMyGoUClient.h
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Communicator.h"

// 数据包
@interface NetMyGoUPacket : NSObject

@property (assign, nonatomic) t_net_header header;
@property (assign, nonatomic) NSMutableData *data;

@end


// 通信客户端
@interface NetMyGoUClient : NSObject

// 登陆

//- (int) login:()

// 注册
//-(int) register:(NetMyGoUPacket*) sendData;



@end
