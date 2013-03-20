#include "socket.h"

namespace moxu
{


bool Socket::Close()
{
#if defined(MOXU_WIN32)
	int ret = ::closesocket(_handle);
#elif defined(MOXU_LINUX)_UNIX
	int ret = ::close(_handle);
#endif
	_handle = INVALID_SOCKET;
	return ret != SOCKET_ERROR;
}

bool Socket::SetNoblock(int flag)
{
#if defined(MOXU_WIN32)
	unsigned long noblock = flag;
	return (::ioctlsocket(_handle, FIONBIO, &noblock) != SOCKET_ERROR);
#elif defined(MOXU_LINUX)
	int arg = ::fcntl(_handle, F_GETFL, 0);
	if (0 == ul)
		arg &= ~O_NONBLOCK;
	else
		arg |= O_NONBLOCK;				
	return (::fcntl(_handle, F_SETFL, flags) != SOCKET_ERROR);
#endif
}

int Socket::GetErrno()
{
#if defined(MOXU_WIN32)
	return WSAGetLastError();
#elif defined(MOXU_LINUX)
	return errno;
#endif
}

} // namespace moxu
