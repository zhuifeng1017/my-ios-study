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
    // 设置为非阻塞
    //int nRet =fcntl (_sk, F_SETFL, O_NONBLOCK | fcntl (_sk, F_GETFL)); // 设置成非阻塞
//    if (nRet == SOCKET_ERROR) {
//        close(_sk);
//        _sk = NULL;
//        return RS_SOCKET_ERROR;
//    }
    
    char msg[32] = "welcome to my echoServer!";
    int nLen = strlen(msg);
    int nRet = send(_sk, msg, nLen, 0);
    if (nRet != nLen) {
        close(_sk);
        _sk = NULL;
        return RS_SOCKET_ERROR;
    }
    
    char buffer[65536];
    while (1) {
        // 接收数据
        int recvLen =recv(_sk, buffer, 65536, 0);
        if (recvLen == 0) { // 对方已关闭
            close(_sk);
            printf("对方已关闭");
            return 0;
        }else if (recvLen <0) // 发生错误
        {
            close(_sk);
            printf("发生错误");
            return -1;
        }
        buffer[recvLen]='\0';
        printf("%s\n", buffer);
        
        int nSendLen = send(_sk, buffer, recvLen, 0);
        if (nSendLen != recvLen) {
            close(_sk);
            _sk = NULL;
            return -1;
        }
    }
    return 0;
}