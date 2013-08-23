//////////////////////////////////////////////////////////////////////////////////////////
// Implementation of the CMemoryMapper class. See .h for details.
// -Vinayak Raghuvamshi
//////////////////////////////////////////////////////////////////////////////////////////
//#include "StdAfx.h"
#include ".\MemoryMapper.h"

CMemoryMapper::CMemoryMapper(void):	m_pFileData(NULL),
									m_dwSize(0),
									m_hFile(INVALID_HANDLE_VALUE),
									m_hMapOfFile(NULL),
									m_pViewOfFile(NULL)
{
}

CMemoryMapper::~CMemoryMapper(void)
{
	try
	{
		Close();
	}
	catch(...)
	{
	}
}

// Opens a file for reading and creates a view of it. Fails if file does not exist.
bool CMemoryMapper::OpenFileForRead(const TCHAR *szFile)
{
	Close();
	m_hFile = CreateFile(	szFile,
							GENERIC_READ,
							FILE_SHARE_READ,
							0,
							OPEN_EXISTING,
							FILE_ATTRIBUTE_NORMAL,
							0
						);

	if(INVALID_HANDLE_VALUE == m_hFile)
		return false;

	return MapFile(m_hFile,PAGE_READONLY,FILE_MAP_READ);
}

// Opens a file mapping for writing. use if we want to modify the file
bool CMemoryMapper::OpenFileForWrite(const TCHAR *szFile)
{
	Close();
	m_hFile = CreateFile(	szFile,
							GENERIC_READ|GENERIC_WRITE,
							FILE_SHARE_READ,
							0,
							OPEN_EXISTING,
							FILE_ATTRIBUTE_NORMAL,
							0
						);

	if(INVALID_HANDLE_VALUE == m_hFile)
		return false;

	return MapFile(m_hFile,PAGE_READWRITE,FILE_MAP_READ|FILE_MAP_WRITE);
}

void CMemoryMapper::Close(void)
{
	if(m_hMapOfFile)
	{
		CloseHandle(m_hMapOfFile);
		m_hMapOfFile = NULL;
	}
	if(m_pViewOfFile)
	{
		UnmapViewOfFile(m_pViewOfFile);
		m_pViewOfFile = NULL;
	}
	if(INVALID_HANDLE_VALUE != m_hFile)
	{
		CloseHandle(m_hFile);
	}

	m_dwSize	= 0;
	m_pFileData = NULL;
}

// internal open method that gets invoked by open for read and open for write....
bool CMemoryMapper::MapFile(const HANDLE &hFile,DWORD dwPageProtect, DWORD dwPageAccess)
{
	m_dwSize = GetFileSize(hFile,0);
	
	if(NULL == (m_hMapOfFile = CreateFileMapping(hFile,NULL,dwPageProtect,NULL,m_dwSize,NULL)))
	{
		Close();
		return false;
	}

	if(NULL == (m_pViewOfFile = MapViewOfFile(m_hMapOfFile,dwPageAccess,0,0,m_dwSize)))
	{
		DWORD dwErr = GetLastError();
		Close();
		return false;
	}

	m_pFileData = reinterpret_cast< BYTE* >(m_pViewOfFile);
	return true;
}
