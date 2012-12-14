//
//  MZPthreadTest.c
//  MyTestAll
//
//  Created by  on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include <pthread.h>

void* threadEntry(void *pVoid){
    return pVoid;
}

void create()
{
    pthread_t pId;
    int nRet = pthread_create(&pId, NULL, threadEntry, NULL);
    if (nRet != 0) {
        return;
    }

    
    

}
