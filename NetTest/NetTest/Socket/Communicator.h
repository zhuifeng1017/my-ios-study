#ifndef COMMUNICATOR_H_
#define COMMUNICATOR_H_

#define INVALID_SOCKET (~0)

#define NET_Header_ID (0x7F)
#define NET_MAX_PACKET_SIZE (8192)


// 数据头
struct t_net_header {
    char head4[4];
    int dataLen;
};


// 网络通信类
class Communicator
{
public:
	Communicator();
	~Communicator();

	int Connect(const char *address, unsigned short port);
	int SendData(const char *buffer, unsigned bufferSize);
    int RecvData(unsigned char* buffer, unsigned bufferLength, unsigned& dateLength);
	int DisConnect();
    
    int RecvHttpData(char *buffer, unsigned bufferSize, unsigned *recvSize);
    
private:
    //int Recv();
	int _sk; // socket handle
};

#endif /*COMMUNICATOR_H_*/
