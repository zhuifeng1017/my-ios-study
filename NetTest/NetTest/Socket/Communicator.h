#ifndef COMMUNICATOR_H_
#define COMMUNICATOR_H_

#define INVALID_SOCKET (~0)

class Communicator
{
public:
	Communicator();
	~Communicator();
	
	int Connect(const char *address, unsigned short port);
	int Send(const char *buffer, unsigned bufferSize);
	int Recv(char *buffer, unsigned bufferSize, unsigned *recvSize);
	int DisConnect();
	
private:
	int _sk; // socket handle
	
};

#endif /*COMMUNICATOR_H_*/
