//////////////////////////////////////////////////////////////////////////////////////////
// A simple but very useful memory mapper class. Very useful when dealing with large files
// that would otherwise be transferred to buffers in the main memory. wave files for eg.
// this class provides a simple interface for mapping a view of the file and treating it
// as a stream of bytes.
//
// -Vinayak Raghuvamshi
//////////////////////////////////////////////////////////////////////////////////////////
#pragma once
#include <windows.h>
class CMemoryMapper
{
public:
	CMemoryMapper(void);
	virtual ~CMemoryMapper(void);
	// Opens a file for reading and creates a view of it. Fails if file does not exist.
	bool OpenFileForRead(const TCHAR *szFile);
	// Opens a file mapping for writing. use if we want to modify the file
	bool OpenFileForWrite(const TCHAR *szFile);
	void Close(void);

	// Gets the underlying Mapped data pointer.
	BYTE* GetPtrToFileData(void)
	{
		return m_pFileData;
	}

	DWORD GetSize(void)
	{
		return m_dwSize;
	}

protected:
	BYTE	*m_pFileData; // subclasses can directly access the file data as a byte *.
	DWORD	m_dwSize;
private:
	HANDLE  m_hFile;
	HANDLE  m_hMapOfFile;
	LPVOID	m_pViewOfFile;
	// internal open method that gets invoked by open for read and open for write....
	bool MapFile(const HANDLE &hFile, DWORD dwPageProtect, DWORD dwPageAccess);
};

