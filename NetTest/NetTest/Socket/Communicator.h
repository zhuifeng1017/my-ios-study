#ifndef COMMUNICATOR_H_
#define COMMUNICATOR_H_


#define NET_Header_ID (0x7F)
#define NET_MAX_PACKET_SIZE (8192)

// 数据头
typedef struct {
    char head4[4];
    int dataLen;
}t_net_header;

// 网络通信类
class Communicator
{
public:
	Communicator();
	~Communicator();

	int Connect(const char *address, unsigned short port);
	int SendData(const char *buffer, unsigned bufferSize);
    int RecvData(unsigned char* buffer, unsigned bufferLength, unsigned& dataLength);
	int DisConnect();
    
    int RecvHttpData(char *buffer, unsigned bufferSize, unsigned *recvSize);
    
private:
    //int Recv();
	int _sk; // socket handle
};

unsigned long long ntohll(unsigned long long val);
unsigned long long htonll(unsigned long long val);

#endif /*COMMUNICATOR_H_*/
