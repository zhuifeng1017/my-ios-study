#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <cstring>
#include <pthread.h>
#include <iostream>
#include <string>

#include "Mutex.h"

using namespace std;

Threads::Mutex *_pMutex;

void* thread(void *pVoid)
{
    Threads::Guard guard(_pMutex);
	int n = 5;
	while (n--){
		printf("%ld, %d\n", (long)pthread_self(), *(int*)pVoid);
		sleep(1);
	}	
	return pVoid;
}


int main(int argc, char** argv)
{
    Threads::Mutex mut;
    _pMutex = &mut;
    
	int nCount = 5;
	pthread_t pId[3];
	for (int i=0; i < 3; ++i)
	{
		int *pData = new int;
		*pData = nCount * i * 1000;
		int nRet = pthread_create(&pId[i], NULL, thread, pData);
		if (nRet != 0)
		{
			exit(-1);
		}
	}
    pthread_join(pId[0], NULL);
    pthread_join(pId[1], NULL);
    pthread_join(pId[2], NULL);
    
    printf("app is exited");
	return 0;
}
