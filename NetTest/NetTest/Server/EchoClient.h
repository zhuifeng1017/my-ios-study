//
//  EchoClient.h
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#ifndef __NetTest__EchoClient__
#define __NetTest__EchoClient__

class EchoClient
{
public:
    int Start(int sk);
    static void* ReadWriteThread(void *arg);
    int ReadWriteThreadEntity();

private:
    int _sk;
};

#endif /* defined(__NetTest__EchoClient__) */
