//
//  EchoServer.cpp
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#include "EchoServer.h"
#include "ErrorCode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#ifdef WIN32
#include <windows.h>
#include <io.h>
#include <winsock.h>
#include <process.h>
#else
#include <unistd.h>
#include <sys/time.h>
#include <pthread.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>
#endif

#include "EchoClient.h"

EchoServer::EchoServer(){
    _started = false;
    _acceptSocket = INVALID_SOCKET;
}

EchoServer::~EchoServer(){
    
}

int EchoServer::StartServer(unsigned short port){
    // 开启监听监听端口
    _listenPort = port;
    _started = false;
    _acceptSocket = INVALID_SOCKET;
    
    pthread_t pThrdListen;
    int nRet = pthread_create(&pThrdListen, NULL, EchoServer::ListenThread, this);
    assert(nRet == 0);
    return nRet;
}

void EchoServer::StopServer(){
    
}

void* EchoServer::ListenThread(void *arg){
    EchoServer *pThis = (EchoServer*)arg;
    pThis->ListenThreadEntity();
    return 0;
}

int EchoServer::ListenThreadEntity()
{
	// create socket
	CreateSocket();
    
	fd_set fdAccept;
	struct timeval tv;
	tv.tv_sec = 10;
	tv.tv_usec = 0;
	int nRet;
	sockaddr_in addr;
	int nAddr = sizeof(addr);
    
    _started = true;
	while (_started)
	{
		// accept and put it to pool
		FD_ZERO(&fdAccept);
		FD_SET(_acceptSocket, &fdAccept);
        
		nRet = select(_acceptSocket+1, &fdAccept, NULL, NULL, &tv);
        
		if (nRet == 0 || !FD_ISSET(_acceptSocket, &fdAccept)) // 超时
        {
            continue;
        }
		else if (nRet < 0)
		{
			_started = false;
			break;
		}
        
		int sock = accept(_acceptSocket, (sockaddr*)&addr, (socklen_t*)&nAddr);
		if (sock == SOCKET_ERROR || sock == 0)
		{
			_started = false;
			break;
		}
        
		linger sLinger;
		sLinger.l_onoff = 1;
		sLinger.l_linger = 0;
		if (SOCKET_ERROR == setsockopt(sock, SOL_SOCKET, SO_LINGER, (char*)&sLinger, sizeof(linger)))
		{
			close(sock);
			continue;
		}
        // 新用户进来
        printf("新用户进来了\n");
        
        // 每个用户一个线程
        EchoClient *pClient = new EchoClient();
        pClient->Start(sock);
    }
    
	close(_acceptSocket);
	_acceptSocket = INVALID_SOCKET;
    _started = false;
	return 0;
}

int EchoServer::CreateSocket()
{
	if(SOCKET_ERROR == (_acceptSocket = socket(AF_INET, SOCK_STREAM, 0)))
		return RS_SOCKET_ERROR;
    
	int nReuse = 1;
	if(SOCKET_ERROR == setsockopt(_acceptSocket, SOL_SOCKET, SO_REUSEADDR, (char*)&nReuse, sizeof(int)))
		return RS_SOCKET_ERROR;
    
	struct sockaddr_in servAddr;
	servAddr.sin_family = AF_INET;
	servAddr.sin_port = htons(_listenPort);
	servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	if(SOCKET_ERROR == bind(_acceptSocket, (sockaddr*)&servAddr, sizeof(sockaddr_in)))
		return RS_SOCKET_ERROR;
    
	if(SOCKET_ERROR == listen(_acceptSocket, SOMAXCONN))
		return RS_SOCKET_ERROR;
    
	return RS_OK;
}
