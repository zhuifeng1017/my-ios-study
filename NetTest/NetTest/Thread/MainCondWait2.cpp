//
//  MainCondWait2.cc
//  NetTest
//
//  Created by uistrong on 13-3-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include "TestXX.h"

#include <queue>
using namespace std;

queue<int> *g_pQue;
pthread_cond_t *g_pCond;
pthread_mutex_t *g_pMutex;


void put(int n){
    pthread_mutex_lock(g_pMutex);
    
    g_pQue->push(n);
    printf("put :%d\n", n);
    pthread_cond_signal(g_pCond);
    
    pthread_mutex_unlock(g_pMutex);
    usleep(5000);
}

void* productorXX(void *){
    int n = 1000;
    while (n--) {
        put(n);
    }
    
    put(-1);

    return NULL;
}



void* consumerXX(void *){
    while (1) {
        pthread_mutex_lock(g_pMutex);
        
        while (g_pQue->empty()) {
            pthread_cond_wait(g_pCond, g_pMutex);
        }
        
        if (!g_pQue->empty()) {
            int nItem = g_pQue->front();
            g_pQue->pop();
            printf("get :%d\n", nItem);
            if (nItem == -1) {
                break;
            }
        }
        
        pthread_mutex_unlock(g_pMutex);
    }
    return NULL;
}

int testXX2(void)
{
    g_pQue = new queue<int>;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    
    g_pMutex = &mutex;
    g_pCond = &cond;
   // 创建两个线程
    pthread_mutex_init(g_pMutex, NULL);
    pthread_cond_init(g_pCond, NULL);
    
    pthread_t pID[2];
    pthread_create(&pID[0], NULL, productorXX, NULL);
    pthread_create(&pID[1], NULL, consumerXX, NULL);

    pthread_join(pID[0], NULL);
    pthread_join(pID[1], NULL);
    
    printf("queue size %d \n", g_pQue->size());
    
    return 0;
}



