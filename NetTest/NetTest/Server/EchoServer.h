//
//  EchoServer.h
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#ifndef __NetTest__EchoServer__
#define __NetTest__EchoServer__

#include <vector>

class EchoServer{
public:
    EchoServer();
    ~EchoServer();

    int StartServer(unsigned short port);
    void StopServer();

private:
    static void* ListenThread(void *arg);
    int ListenThreadEntity();
    int ReadWriteThreadEntity();
    int CreateSocket();
private:
    bool _started;
    int _acceptSocket;
    unsigned short _listenPort;
    std::vector<int> _clients;
};


#endif /* defined(__NetTest__EchoServer__) */
