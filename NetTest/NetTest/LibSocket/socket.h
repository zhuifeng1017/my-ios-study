#ifndef MOXU_SOCKET_H
#define MOXU_SOCKET_H

#define MOXU_LINUX

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <sys/time.h>
#include <pthread.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>

namespace moxu
{

#if defined(MOXU_WIN32)
#  define MSG_NOSIGNAL	(0)

#elif defined(MOXU_LINUX)
typedef int SOCKET;
#  define INVALID_SOCKET	(-1)
#  define SOCKET_ERROR		(-1)
#endif

#ifndef SD_RECEIVE
#  define SD_RECEIVE      0x00
#  define SD_SEND         0x01
#  define SD_BOTH         0x02
#endif

class Socket// : private NonCopyable
{
public:
	Socket(SOCKET handle = INVALID_SOCKET)
		: _handle(handle)
	{
	}

	~Socket(){}

	operator SOCKET () const { return _handle; }

	bool Create(unsigned short port = 0, int type = SOCK_STREAM, const char* addr = NULL)
	{
		_handle = ::socket(AF_INET, type, 0);
		if (_handle == INVALID_SOCKET)
			return false;

		return Bind(port, addr);
	}

	bool Bind(unsigned short port, const char* addr = NULL)
	{
		sockaddr_in saddri;
		::memset(&saddri, 0, sizeof(saddri));
		saddri.sin_family = AF_INET;
		saddri.sin_port = ::htons(port);
		if (addr == NULL)
		{
			saddri.sin_addr.s_addr = ::htonl(INADDR_ANY);
		}
		else
		{
			saddri.sin_addr.s_addr = ::inet_addr(addr);
			if (saddri.sin_addr.s_addr == INADDR_NONE)
			{
				LPHOSTENT host = ::gethostbyname(addr);
				if (host == NULL)
				{
					return false;
				}
				saddri.sin_addr.s_addr = ((LPIN_ADDR)host->h_addr)->s_addr;		
			}
		}	
		return Bind((SOCKADDR*)&saddri);
	}

	bool Bind(const SOCKADDR* saddr)
	{
		return ::bind(_handle, saddr, sizeof(SOCKADDR)) != SOCKET_ERROR;
	}

	bool Listen(int backlog = 0xFFFF)
	{
		return ::listen(_handle, backlog) != SOCKET_ERROR;
	}

	bool Connect(const char* addr, unsigned short port)
	{
		sockaddr_in saddri;
		::memset(&saddri, 0, sizeof(saddri));
		saddri.sin_family	= AF_INET;
		saddri.sin_port = ::htons(port);
		saddri.sin_addr.s_addr = ::inet_addr(addr);

		if (saddri.sin_addr.s_addr == INADDR_NONE)
		{
			LPHOSTENT host = ::gethostbyname(addr);
			if (host == NULL)
			{
				return false;
			}
			saddri.sin_addr.s_addr = ((LPIN_ADDR)host->h_addr)->s_addr;		
		}

		return Connect((SOCKADDR*)&saddri);
	}

	bool Connect(const SOCKADDR* saddr)
	{
		return ::connect(_handle, saddr, sizeof(SOCKADDR)) != SOCKET_ERROR;
	}

	Socket Accept(SOCKADDR* saddr = NULL, int* saddrlen = NULL)
	{
		Socket client;
		client._handle = ::accept(_handle, saddr, saddrlen);
		return client;
	}

	int Send(const char* buf, int len, int flags = MSG_NOSIGNAL)
	{
		return ::send(_handle, buf, len, flags);
	}

	int Receive(char* buf, int len, int flags = MSG_NOSIGNAL)
	{
		return ::recv(_handle, buf, len, flags);
	}

	bool GetSockopt(int level, int optname, char* optvalue, int* optlen)
	{
		return ::getsockopt(_handle, level, optname, optvalue, optlen) == NO_ERROR;
	}

	bool SetSockopt(int level, int optname, const char* optvalue, int optlen)
	{
		return ::setsockopt(_handle, level, optname, optvalue, optlen) == NO_ERROR;
	}

	bool Shutdown(int how = SD_BOTH)
	{
		return ::shutdown(_handle, how) == NO_ERROR;
	}

	bool Close();

	// @param flag 允许非阻塞模式传入非0，禁止非阻塞模式传入零
	bool SetNoblock(int flag);

	static int Select(fd_set* readfds, fd_set* writefds, 
		fd_set* exceptfds, timeval* timeout)
	{
		int nfds = 0;
#if defined(MOXU_LINUX)
		if (readfds != 0)
			nfds = MaxFd(readfds, nfds);
		if (writefds != 0)
			nfds = MaxFd(writefds, nfds);
		if (exceptfds != 0)
			nfds = MaxFd(exceptfds, nfds);
		nfds += 1;
#endif
		return ::select(nfds, readfds, writefds, exceptfds, timeout);
	}

	static int GetErrno();

private:
#if defined(MOXU_LINUX)
	static int MaxFd(fd_set* fd, int curfd)
	{
		int maxfd = curfd;
		for (unsigned i = 0; i < fd->fd_count; ++i)
			maxfd = (maxfd>(int)(fd->fd_array[i]) ? maxfd : (int)fd->fd_array[i]);
		return maxfd;
	}
#endif
	SOCKET _handle;
};

} // namespace moxu

#endif // MOXU_SOCKET_H
