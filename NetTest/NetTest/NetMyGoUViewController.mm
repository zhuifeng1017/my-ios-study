//
//  NetMyGoUViewController.m
//  NetTest
//
//  Created by uistrong on 13-3-19.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "NetMyGoUViewController.h"

#include "md5.h"
#include "Crc.h"

#include "ErrorCode.h"
#include "Communicator.h"

#include "TestXX.h"

@interface NetMyGoUViewController ()

@end

@implementation NetMyGoUViewController

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

-(IBAction)actionLogin:(id)sender{
    // 登陆
    [self showWait];
    //[self performSelector:@selector(login) withObject:nil afterDelay:0.3];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    [self login];
    [self hiddWait];
}

- (void) login
{
    Communicator comm;
    int nRet = comm.Connect("192.168.108.13", 33886);
    if (nRet != SUCCESS) {
        NSLog(@"连接失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    t_net_header header;
    memset(&header, 0, sizeof(header));
    header.head4[0] = NET_Header_ID;
    header.head4[1] = 0x01;
    header.head4[2] = 0x01;
    header.head4[3] = 0x02;
    
    NSMutableData *mData = [[NSMutableData alloc] init];
    [mData appendBytes:&header length:sizeof(header)]; // append header
    
    short nLen = strlen("li_guotao");
    short nNetLen = htons(nLen); // 转为大端
    [mData appendBytes:&nNetLen length:2];
    [mData appendBytes:"li_guotao" length:nLen]; // append username
    
    char *rstPass = moxu::Md5String((char*)"123456");
    NSLog(@"%s", rstPass); // e10adc3949ba59abbe56e057f20f883e
    char md5Pass[32] = {0};
    strcpy(md5Pass, rstPass);
    [mData appendBytes:md5Pass length:32]; // append password
    
    char cFrm = 2;
    [mData appendBytes:&cFrm length:1];
    
    char devID[32] = "12345612";
    nLen = strlen(devID);
    nNetLen = htons(nLen); // 转为大端
    [mData appendBytes:&nNetLen length:2];
    [mData appendBytes:devID length:nLen];
    
    //更新头长度
    int nDataLen = [mData length] - sizeof(header);
    int nNetDataLen = htonl(nDataLen); // 转为大端
    NSRange rg = {4, 4};
    [mData replaceBytesInRange:rg withBytes:&nNetDataLen];
    
    // CRC校验码
    long llCrc = crc32(0, (char*)[mData bytes], (int)[mData length]);
    llCrc = htonl(llCrc); // 转为大端
    
    int nSpace = 0;
    [mData appendBytes:&nSpace length:4];
    [mData appendBytes:&llCrc length:4];
    
    // 发送数据
    nRet = comm.SendData((char*)[mData bytes], [mData length]);
    if (nRet != SUCCESS) {
        NSLog(@"发送失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    unsigned char buffer[NET_MAX_PACKET_SIZE];
    unsigned int dataLength = 0;
    nRet = comm.RecvData(buffer, NET_MAX_PACKET_SIZE, dataLength);
    if (nRet != SUCCESS) {
        NSLog(@"接收失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    comm.DisConnect();
    NSLog(@"接收成功：ret: %d", nRet);
    NSLog(@"%p", buffer);
    
    // 解析返回包
    if (buffer[0] != 0) { // 状态码
        NSLog(@"服务器返回error %d", buffer[0]);
    }
    
    // 状态信息
    short stateInfoLen;
    memcpy(&stateInfoLen, &buffer[1], sizeof(short));
    stateInfoLen = ntohs(stateInfoLen);
    
    int nPtr = 1 + sizeof(short);
    if (stateInfoLen) {
        char stateInfo[512];
        memcpy(stateInfo, &buffer[nPtr], stateInfoLen);
        stateInfo[stateInfoLen] = '\0';
        NSLog(@"state: %s", stateInfo);
    }
    
    nPtr += stateInfoLen;
    //登录令牌  8字节

    memcpy(&_token, &buffer[nPtr], 8);
    _token = ntohll(_token);
    NSLog(@"token %llx", _token);
    
    nPtr += 8;
    // 服务器ip 8字节
    short ipAddr[4];
    memcpy(ipAddr, &buffer[nPtr], 8);
    
    NSLog(@"addr: %d.%d.%d.%d", ntohs(ipAddr[0]), ntohs(ipAddr[1]), ntohs(ipAddr[2]), ntohs(ipAddr[3]) );
    
    nPtr +=8;
    // 服务器端口 4字节
    int nPort;
    memcpy(&nPort, &buffer[nPtr], 4);
    nPort = ntohl(nPort);
    NSLog(@"port: %d", nPort);
    
    _ipAddr = [[NSString stringWithFormat:@"%d.%d.%d.%d",ntohs(ipAddr[0]), ntohs(ipAddr[1]), ntohs(ipAddr[2]), ntohs(ipAddr[3])] retain];
    _port = nPort;
}


-(IBAction)actionAlive:(id)sender{
    [self showWait];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    [self alive];
    [self hiddWait];
}

// 不需要token
- (void) alive{
    Communicator comm;
    int nRet = comm.Connect(_ipAddr.UTF8String, _port);
    if (nRet != SUCCESS) {
        NSLog(@"连接失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    char mData[1] = {0x01};
    // 发送数据
    nRet = comm.SendData(mData, 1);
    if (nRet != SUCCESS) {
        NSLog(@"发送失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    unsigned char buffer[1];
    unsigned int dataLength = 0;
    nRet = comm.RecvAliveData(buffer, 1, dataLength);
    if (nRet != SUCCESS) {
        NSLog(@"接收失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    comm.DisConnect();
    NSLog(@"接收成功：ret: %d", nRet);
    NSLog(@"心跳返回包: %d", (int)buffer[0]);
}

- (void) showWait{
    if (_processAlertView == nil) {
        _processAlertView = [[UIAlertView alloc]
                             initWithTitle:@"正在连接..."
                             message:nil
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
        UIActivityIndicatorView *Activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 65, 20, 20)];
        [Activity startAnimating];
        [_processAlertView addSubview:Activity];
    }
    [_processAlertView show];
}

- (void) hiddWait{
    if (_processAlertView != nil) {
        [_processAlertView dismissWithClickedButtonIndex:0 animated:YES];
        [_processAlertView release];
        _processAlertView = nil;
    }
}

-(IBAction)actionTestXX:(id)sender{
    testXX2();
}

- (void) getUserInfo{
    Communicator comm;
    int nRet = comm.Connect(_ipAddr.UTF8String, _port);
    if (nRet != SUCCESS) {
        NSLog(@"连接失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    t_net_header header;
    memset(&header, 0, sizeof(header));
    header.head4[0] = NET_Header_ID;
    header.head4[1] = 0x01;
    header.head4[2] = 0x10;
    header.head4[3] = 0x02;
    header.dataLen = htonl(8);
    
    NSMutableData *mData = [[NSMutableData alloc] init];
    [mData appendBytes:&header length:sizeof(header)]; // append header
    
// 1. 登陆令牌
    long long llNetToken = htonll(_token);// 转为大端
    [mData appendBytes:&llNetToken length:8];
    
// 2.CRC校验码
    long llCrc = crc32(0, (char*)[mData bytes], (int)[mData length]);
    llCrc = htonl(llCrc); // 转为大端
    int nSpace = 0;
    [mData appendBytes:&nSpace length:4];
    [mData appendBytes:&llCrc length:4];
    
    // 发送数据
    nRet = comm.SendData((char*)[mData bytes], [mData length]);
    if (nRet != SUCCESS) {
        NSLog(@"发送失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    unsigned char buffer[NET_MAX_PACKET_SIZE];
    unsigned int dataLength = 0;
    nRet = comm.RecvData(buffer, NET_MAX_PACKET_SIZE, dataLength);
    if (nRet != SUCCESS) {
        NSLog(@"接收失败：ret: %d", nRet);
        comm.DisConnect();
        return;
    }
    
    // 关闭连接
    comm.DisConnect();
    
    NSLog(@"接收成功：ret: %d", nRet);
    NSLog(@"%p", buffer);
    
    // 解析返回包
    if (buffer[0] != 0) { // 状态码
        NSLog(@"服务器返回error %d", buffer[0]);
    }
    
    // 状态信息
    short stateInfoLen;
    memcpy(&stateInfoLen, &buffer[1], sizeof(short));
    stateInfoLen = ntohs(stateInfoLen);
    
    int nPtr = 1 + sizeof(short);
    if (stateInfoLen) {
        char stateInfo[512];
        memcpy(stateInfo, &buffer[nPtr], stateInfoLen);
        stateInfo[stateInfoLen] = '\0';
        NSLog(@"state: %s", stateInfo);
    }
    nPtr += stateInfoLen;
 // 用户编号
    nPtr += 8;
 // 姓名
    short nNameLen;
    memcpy(&nNameLen, &buffer[nPtr], sizeof(short));
    nPtr += sizeof(short);
    nNameLen = ntohs(nNameLen);
    if (nNameLen) {
        char szName[64];
        memcpy(szName, &buffer[nPtr], nNameLen);
        szName[nNameLen] = '\0';
        NSString * strName = [NSString stringWithUTF8String:szName];
        NSLog(@"name: %@", strName);
    }
    
    /*
    数据格式：
    序号	名  称	数据类型	长  度	备注
    1	状态码	BYTE	1
    2	状态信息	LSTRING	可变
    3	用户编号	LONG	8
    4	姓名	LSTRING	可变
    5	性别	BYTE	1	  0x00保密
    0x01男
    0x02女
    6	生日	LONG	8
    7	邮箱	LSTRING	可变
    8	所在地	LSTRING	可变
    9	手机号	LSTRING	可变
    10	导航仪型号	LSTRING	可变
    11	车型	LSTRING	可变
    12	新浪绑定token	LSTRING	可变
    13	新浪绑定sina_uid	LSTRING	可变
    14	新浪有效期	LSTRING	可变
    15	腾讯绑定token	LSTRING	可变
    16	腾讯有效期	LSTRING	可变
    17	腾讯openid	LSTRING	可变	
    18	腾讯openkey	LSTRING	可变	
    19	读取系统消息时间	LONG	8
    */
    

}

-(IBAction)actionUserInfo:(id)sender
{
    [self showWait];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    [self getUserInfo];
    [self hiddWait];
}


@end
