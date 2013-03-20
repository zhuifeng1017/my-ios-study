
#include <stdio.h>
#include <stdlib.h>
#include "EchoServer.h"

#define EchoServer 0

#if EchoServer

int main(int argc, char** argv){
    EchoServer server;
    server.StartServer(8888);
    getchar();
    printf("exited");
    return 0;
}


#endif

