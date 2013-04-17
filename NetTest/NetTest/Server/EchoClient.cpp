//
//  EchoClient.cpp
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <assert.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <unistd.h>
#include "EchoClient.h"
#include "ErrorCode.h"

int EchoClient::Start(int sk){
    _sk = sk;
    
    pthread_t pThrdClient;
    int nRet = pthread_create(&pThrdClient, NULL, EchoClient::ReadWriteThread, this);
    assert(nRet == 0);
    
    return 0;
}

void* EchoClient::ReadWriteThread(void *arg){
    EchoClient *pThis = (EchoClient*)arg;
    pThis->ReadWriteThreadEntity();
    return 0;
}

int EchoClient::ReadWriteThreadEntity(){
    char msg[32] = "welcome to my echoServer!";
    int nLen = strlen(msg);
    int nRet = send(_sk, msg, nLen, 0);
    if (nRet != nLen) {
        close(_sk);
        _sk = NULL;
        return RS_SOCKET_ERROR;
    }
    
    // 设置为非阻塞
    nRet =fcntl (_sk, F_SETFL, O_NONBLOCK | fcntl (_sk, F_GETFL));
    if (nRet == SOCKET_ERROR) {
        close(_sk);
        _sk = NULL;
        return RS_SOCKET_ERROR;
    }
    
    char buffer[65580];
    int nHeaderLen = 0;

#define USE_MARK 0
#define USE_LENGTH 1
    
// 模拟数据头 \r\n标记符
#if USE_MARK
    char szHeader[32] = "这是数据头\r\n";
    nHeaderLen = strlen(szHeader);
    memcpy(buffer, szHeader, nHeaderLen);
#endif
    
// 模拟协议头
#if USE_LENGTH
    struct t_header{
        int ID;
        int length;
    };
    nHeaderLen = sizeof(struct t_header);
    t_header tempHeader = {0, 0};
    memcpy(buffer, &tempHeader, nHeaderLen);
#endif
    
    fd_set fdset;
    timeval tmv;
    while (1) {
        // 接收数据, 判断是否有数据可读
		FD_ZERO(&fdset);
		FD_SET(_sk, &fdset);
		tmv.tv_sec = 10; // 设定超时时间
		tmv.tv_usec = 0;
        
        int nRet = select(_sk+1, &fdset, 0, 0, &tmv);
		if (nRet == 0) // 超时
        {

            printf("用户10s没发数据了,给他推送一个消息\n");
            
            char msg[16] = "消息1";
            int nMsgLen = strlen(msg);
            memcpy(buffer+nHeaderLen, msg, nMsgLen);
#if USE_LENGTH
            // 填充头部
            t_header *pHeader = (t_header*)buffer;
            pHeader->ID = 1;
            pHeader->length = nMsgLen;
#endif

            int nSendMsgLen = send(_sk, buffer, nMsgLen+nHeaderLen, 0);
            if (nSendMsgLen != nMsgLen+nHeaderLen) {
                printf("推送消息发生错误\n");
                close(_sk);
                _sk = NULL;
                return -1;
            }

            continue;
        }else if(nRet < 0){
            close(_sk);
            _sk = NULL;
            printf("发生错误\n");
            return -1;
        }
        
        int recvLen =recv(_sk, buffer+nHeaderLen, 65535, 0);
        if (recvLen == 0) { // 对方已关闭
            close(_sk);
            _sk = NULL;
            printf("对方已关闭\n");
            return 0;
        }else if (recvLen <0) // 发生错误
        {
            close(_sk);
            printf("发生错误\n");
            return -1;
        }
        
        buffer[recvLen+nHeaderLen]='\0';
        printf("%s\n", buffer+nHeaderLen); // 打印接收到的数据
        
#if USE_LENGTH        
        // 填充头部
        t_header *pHeader = (t_header*)buffer;
        pHeader->ID = 0;
        pHeader->length = recvLen;
#endif
        
        int nSendLen = send(_sk, buffer, recvLen+nHeaderLen, 0);
        if (nSendLen != recvLen+nHeaderLen) {
            printf("发送数据发生错误\n");
            close(_sk);
            _sk = NULL;
            return -1;
        }
    }
    return 0;
}