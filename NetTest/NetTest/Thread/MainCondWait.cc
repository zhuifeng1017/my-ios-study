//
//  Main2.cpp
//  NetTest
//
//  Created by uistrong on 13-3-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include "TestXX.h"

// 生成者消费者模型实现
// 使用事件通知线程同步。生产者每生成一个就通知消费者来取

#define BUFFER_SIZE 50

struct prodcons
{
    int buffer[BUFFER_SIZE];
    pthread_mutex_t lock;/*互斥锁*/
    int readpos, writepos;
    pthread_cond_t notempty;/*缓冲区非空信号*/
    pthread_cond_t notfull;/*缓冲区非满信号*/
};

#define OVER (-1)
struct prodcons buffer;

void init(struct prodcons *b)
{
    pthread_mutex_init(&b->lock, NULL);
    pthread_cond_init(&b->notempty, NULL);
    pthread_cond_init(&b->notfull, NULL);
    b->readpos = 0;
    b->writepos = 0;
}

void put(struct prodcons *b, int data)
{
    pthread_mutex_lock(&b->lock);//获取互斥锁
    while((b->writepos + 1) % BUFFER_SIZE == b->readpos)
    {
        printf("wait for not full\n");
        pthread_cond_wait(&b->notfull, &b->lock);//不满时逃出阻塞
    }
    b->buffer[b->writepos] = data;
    b->writepos++;
    if(b->writepos >= BUFFER_SIZE)
        b->writepos = 0;
    pthread_cond_signal(&b->notempty);//设置状态变量
    pthread_mutex_unlock(&b->lock);//释放互斥锁
}

int get(struct prodcons *b)
{
    int data;
    pthread_mutex_lock(&b->lock);
    while(b->writepos == b->readpos)
    {
        printf("wait for not empty\n");
        pthread_cond_wait(&b->notempty, &b->lock);
    }
    data = b->buffer[b->readpos];
    b->readpos++;
    if(b->readpos >= BUFFER_SIZE)
        b->readpos = 0;
    pthread_cond_signal(&b->notfull);
    pthread_mutex_unlock(&b->lock);
    return data;
}

void *producer(void *data)
{
    int n;
    for(n=10; n<1000; n++)
    {
        printf("put->%d\n",n);
        put(&buffer, n);
    }
    put(&buffer, OVER);
    printf("producer stopped\n");
    return NULL;
}

void *consumer(void *data)
{
    int d;
    while(1)
    {
        d = get(&buffer);
        if(d == OVER)
            break;
        printf("%d->get\n",d);
    }
    printf("consumer stopped!\n");
    return NULL;
}

// 测试代码
int testXX(void)
{
    pthread_t th_a, th_b;
    void *retval;
    init(&buffer);
    pthread_create(&th_a, NULL, producer, 0);
    pthread_create(&th_b, NULL, consumer, 0);
    pthread_join(th_a, &retval);
    pthread_join(th_b, &retval);
    return 0;
}