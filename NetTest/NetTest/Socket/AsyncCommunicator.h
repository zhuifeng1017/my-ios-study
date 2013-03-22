//
//  AsyncCommunicator.h
//  NetTest
//
//  Created by uistrong on 13-3-20.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#ifndef __NetTest__AsyncCommunicator__
#define __NetTest__AsyncCommunicator__

// 异步通讯类

class AsyncCommunicator{
public:
    AsyncCommunicator();
    ~AsyncCommunicator();
    
    
    
private:
    int _sk; // socket handle

};

#endif /* defined(__NetTest__AsyncCommunicator__) */
