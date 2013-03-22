//
//  Event.h
//  NetTest
//
//  Created by uistrong on 13-3-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#ifndef NetTest_Event_h
#define NetTest_Event_h


typedef struct
{
    bool state;
    bool manual_reset;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
}event_t;

#define event_handle event_t*


//返回值：NULL 出错
event_handle event_create(bool manual_reset, bool init_state);

//返回值：0 等到事件，-1出错
int event_wait(event_handle hevent);

//返回值：0 等到事件，1 超时，-1出错
int event_timedwait(event_handle hevent, long milliseconds);

//返回值：0 成功，-1出错
int event_set(event_handle hevent);

//返回值：0 成功，-1出错
int event_reset(event_handle hevent);

//返回值：无
void event_destroy(event_handle hevent);


#endif
