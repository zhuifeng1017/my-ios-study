//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation for the CWaveFileHandler. Please see the .h for more information 
// -Vinayak Raghuvamshi
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "StdAfx.h"
#include <windows.h>
#include ".\MemoryMapper.h"
#include ".\WaveFileHandler.h"

const unsigned int STANDARD_WAVEFORMAT_SIZE = 16;

CWaveFileHandler::CWaveFileHandler(void):m_pMemoryMap(NULL),m_hFile(NULL)
{
	InitMembers(BOTH);
}

CWaveFileHandler::~CWaveFileHandler(void)
{
	InitMembers(BOTH);
}

// Opens a wav file for reading. fails if not exists. throws tchar * exception
void CWaveFileHandler::OpenForRead(const TCHAR* szFile)
{
	InitMembers(READ);
	try
	{
		m_pMemoryMap = new CMemoryMapper;
		if(!m_pMemoryMap->OpenFileForRead(szFile))
			throw "CWaveFileHandler::OpenForRead, Failed to open file mapping";

		BYTE *pFileData = m_pMemoryMap->GetPtrToFileData();
		if(NULL == pFileData)
			throw "CWaveFileHandler::OpenForRead, memorymapper returns NULL ptr.";

		// Verify Riff
		m_pRiffHeader = reinterpret_cast< RIFF_HEADER* >(pFileData);
		if(!IsValidRiffHeader(m_pRiffHeader))
			throw "CWaveFileHandler::OpenForRead, Invalid or corrupt Riff header. 'RIFF' or 'WAVE' missing.";
		
		// Riff OK. Verify fmt.
		pFileData += sizeof(*m_pRiffHeader);
		m_pFmtHeader = reinterpret_cast< FMT_BLOCK* >(pFileData);
		if(!IsValidFmtChunk(m_pFmtHeader))
			throw "CWaveFileHandler::OpenForRead, Invalid or corrupt fmt block. 'fmt ' missing.";

		// Fmt OK. Verify Data
		// taken care of varying fmt block sizes.
		pFileData += sizeof(*m_pFmtHeader);
		// fmt size is "always" 16 for windows wave files. But some compressed versions have this bigger.
		// the extra stuff is then after the waveformat but before the data.
		if(m_pFmtHeader->dwFmtSize > STANDARD_WAVEFORMAT_SIZE)
		{
			pFileData += (m_pFmtHeader->dwFmtSize - STANDARD_WAVEFORMAT_SIZE);
		}
		m_pDataBlock = reinterpret_cast< DATA_BLOCK* >(pFileData);
		if(!IsValidDataBlock(m_pDataBlock))
			throw "CWaveFileHandler::OpenForRead, Invalid or corrupt data block. 'data' missing.";

		// Read succesfull !! The riff, fmt and data block offsets are now in our member vars. njoy..
		pFileData += sizeof(*m_pDataBlock);
		m_pStartOfData = pFileData;
	}
	catch(...)
	{
		InitMembers(READ);
		throw;
	}
}

// opens wav for writing. overwrites if specified. throws tchar* exception
void CWaveFileHandler::OpenForWrite(const TCHAR* szFile, bool bOverWrite)
{
	InitMembers(WRITE);
	try
	{
		DWORD dwCreation = bOverWrite ? CREATE_ALWAYS:CREATE_NEW;
		m_hFile = CreateFile(	szFile,
								GENERIC_READ|GENERIC_WRITE,
								FILE_SHARE_READ,
								0,
								dwCreation,
								FILE_ATTRIBUTE_NORMAL,
								0
								);

		if((INVALID_HANDLE_VALUE == m_hFile)||(NULL == m_hFile))
			throw "CWaveFileHandler::OpenForWrite, Failed to open file for writing.";
	}
	catch(...)
	{
		DWORD dwErr = GetLastError();
		InitMembers(WRITE);
		throw;
	}
}

BYTE* CWaveFileHandler::GetRiff(DWORD& dwRiffChunckSize)
{
	dwRiffChunckSize = sizeof(*m_pRiffHeader);
	return reinterpret_cast< BYTE* >(m_pRiffHeader);
}

// Gets the fmt block chunck. 
BYTE* CWaveFileHandler::GetFmt(DWORD& dwSize)
{
	// total size of the fmt block
	dwSize = sizeof(*m_pFmtHeader) + m_pFmtHeader->dwFmtSize - STANDARD_WAVEFORMAT_SIZE;
	return reinterpret_cast< BYTE* >(m_pFmtHeader);
}

// Gets the actual data block ptr. actually, a ptr to the map view of this wav file.
BYTE* CWaveFileHandler::GetData(DWORD& dwSize)
{
	// data block plus the data
	dwSize = m_pDataBlock->dwDataSize + sizeof(*m_pDataBlock);
	return reinterpret_cast< BYTE* >(m_pDataBlock);
}

// Gets the raw data, i.e, without the datablock header.
BYTE* CWaveFileHandler::GetRawData(DWORD& dwSize)
{
	// data block plus the data
	dwSize = m_pDataBlock->dwDataSize;
	return reinterpret_cast< BYTE* >(m_pStartOfData);
}

// writes the riff header to the wav file.
void CWaveFileHandler::PutRiff(BYTE* pRiff, DWORD dwSize)
{
	try
	{
		// Riff header is always the first chunk.
		DWORD dwPtr = SetFilePointer(m_hFile, 0, NULL, FILE_BEGIN); 
 		if (dwPtr == INVALID_SET_FILE_POINTER) // Test for failure
		{
			throw "CWaveFileHandler::PutRiff, failed to move file pointer to the beginning.";
		}

		DWORD dwWritten = 0;
		::WriteFile(m_hFile,pRiff,dwSize,&dwWritten,NULL);
		m_dwWritten += dwWritten;
	}
	catch(...)
	{
		InitMembers(WRITE);
		throw;
	}
}

// writes the fmt block
void CWaveFileHandler::PutFmt(BYTE* pFmt, DWORD dwSize)
{
	try
	{
		DWORD dwWritten = 0;
		::WriteFile(m_hFile,pFmt,dwSize,&dwWritten,NULL);
		m_dwWritten += dwWritten;
	}
	catch(...)
	{
		InitMembers(WRITE);
		throw "CWaveFileHandler::PutFmt, failed to write format chunk.";
	}
}

// writes the header. adds a riff if absent in the header. use this version if u are not sure what ur header contains.
void CWaveFileHandler::PutHeader(BYTE* pHeader, DWORD dwSize)
{
	try
	{
		// verify and add Riff header.
		if(!IsValidRiffHeader(pHeader))
		{
			// Lets add a RIFF.
			RIFF_HEADER rh;
			GetARiffChunk(rh);
			PutRiff(reinterpret_cast< BYTE* >(&rh),sizeof(rh));
		}
		else
		{
			// valid riff. 
			PutRiff(pHeader,sizeof(RIFF_HEADER));
			pHeader += sizeof(RIFF_HEADER);
			dwSize -= sizeof(RIFF_HEADER);
		}

		// verify and Add fmt.
		if(!IsValidFmtChunk(pHeader))
			throw "CWaveFileHandler::PutHeader, invalid or corrupt Fmt chunk.";

		PutFmt(pHeader,dwSize);
	}
	catch(...)
	{
		InitMembers(WRITE);
		throw;
	}
}

// writes the actual data. A user can set up the riff and fmt chunks and then invoke putdata many times
// we will keep appending the data bytes and modifying the size in the riff header after each data block
// write is done.
void CWaveFileHandler::PutData(BYTE* pData, DWORD dwSize)
{
	try
	{
		DWORD dwWritten = 0;
		if(!IsValidDataBlock(pData))
		{
			DATA_BLOCK db = {0};
			GetADataBlock(db);
			db.dwDataSize = dwSize;
			WriteFile(m_hFile,&db,sizeof(db),&dwWritten,NULL);
			m_dwWritten += dwWritten;
		}
		
		dwWritten = 0;
		WriteFile(m_hFile,pData,dwSize,&dwWritten,NULL);
		m_dwWritten += dwWritten;
		dwWritten = m_dwWritten;
		FlushFileBuffers(m_hFile);

		// ensure that the datasize is set right in the riff header.
		RIFF_HEADER rh;
		GetARiffChunk(rh);
		rh.dwRiffSize = m_dwWritten;
		PutRiff(reinterpret_cast< BYTE* >(&rh),sizeof(rh));
		m_dwWritten = dwWritten;
		FlushFileBuffers(m_hFile);

		SetFilePointer(m_hFile,m_dwWritten,NULL,FILE_BEGIN);

	}
	catch(...)
	{
		InitMembers(WRITE);
		throw;
	}
}

// puts raw data. i.e data without datablock. if data contains data block it will be stripped out
void CWaveFileHandler::PutRawData(BYTE* pData, DWORD dwSize)
{

	try
	{
		if(IsValidDataBlock(reinterpret_cast< DATA_BLOCK* >(pData)))
		{
			// we need to write raw data, this guy has a datablock header, strip it out. 
			pData  += sizeof(DATA_BLOCK);
			dwSize -= sizeof(DATA_BLOCK);
		}
		DWORD dwWritten = 0;
		WriteFile(m_hFile,pData,dwSize,&dwWritten,NULL);
		m_dwWritten += dwWritten;
		dwWritten = m_dwWritten;

		// ensure that the datasize is set right in the riff header.
		RIFF_HEADER rh;
		GetARiffChunk(rh);
		rh.dwRiffSize = dwWritten;
		PutRiff(reinterpret_cast< BYTE* >(&rh),sizeof(rh));
		m_dwWritten = dwWritten;
		FlushFileBuffers(m_hFile);
		
		// adjust the data size in the data block
		DWORD dwBytesTillDataBlock = 0;
		dwBytesTillDataBlock += sizeof(RIFF_HEADER);
		// file ptr is just after riff block now.
		FMT_BLOCK fb;
		DWORD dwRead = 0;
		::ReadFile(m_hFile,&fb,sizeof(fb),&dwRead,NULL);
		dwBytesTillDataBlock += sizeof(fb);
		if(fb.dwFmtSize > STANDARD_WAVEFORMAT_SIZE)
			dwBytesTillDataBlock += (fb.dwFmtSize - STANDARD_WAVEFORMAT_SIZE);

		DWORD dwPtr = SetFilePointer(m_hFile, dwBytesTillDataBlock, NULL, FILE_BEGIN); 
		if (dwPtr == INVALID_SET_FILE_POINTER) // Test for failure
		{
			throw "CWaveFileHandler::PutData, failed to move file pointer to data block.";
		}
		DATA_BLOCK db;
		::ReadFile(m_hFile,&db,sizeof(db),&dwRead,NULL);
		db.dwDataSize += dwSize;
		dwPtr = SetFilePointer(m_hFile, dwBytesTillDataBlock, NULL, FILE_BEGIN); 
		if (dwPtr == INVALID_SET_FILE_POINTER) // Test for failure
		{
			throw "CWaveFileHandler::PutData, failed to move file pointer to data block.";
		}
		// write the modifyed data block
		::WriteFile(m_hFile,&db,sizeof(db),&dwWritten,NULL);
		FlushFileBuffers(m_hFile);
		// reset the file pointer to the curr pos. (end).
		dwPtr = SetFilePointer(m_hFile, m_dwWritten, NULL, FILE_BEGIN); 
 		if (dwPtr == INVALID_SET_FILE_POINTER) // Test for failure
		{
			throw "CWaveFileHandler::PutData, failed to move file pointer to the end.";
		}
	}
	catch(...)
	{
		InitMembers(WRITE);
		throw;
	}

}

// initialize all member vars
void CWaveFileHandler::InitMembers(eInitMode eMode)
{
	if((BOTH == eMode) || (READ == eMode))
	{
		if(m_pMemoryMap)
		{
			try
			{
				delete m_pMemoryMap;
				m_pMemoryMap = NULL;
			}
			catch(...)
			{
			}
		}

		m_pStartOfData	= NULL;
		m_pRiffHeader	= NULL;
		m_pFmtHeader	= NULL;
		m_pDataBlock	= NULL;
	}

	if((BOTH == eMode) || (WRITE == eMode))
	{
		m_dwWritten = 0;
		if((INVALID_HANDLE_VALUE != m_hFile) && (NULL != m_hFile))
		{
			try
			{
				CloseHandle(m_hFile);
				m_hFile = NULL;
			}
			catch(...)
			{
			}
		}
	}
}

bool CWaveFileHandler::IsValidRiffHeader(void* pHeader)
{
	RIFF_HEADER *pRiffHeader = reinterpret_cast< RIFF_HEADER* >(pHeader);
	if(!(	(pRiffHeader->szRiffID[0] == 'R') &&
			(pRiffHeader->szRiffID[1] == 'I') &&
			(pRiffHeader->szRiffID[2] == 'F') &&
			(pRiffHeader->szRiffID[3] == 'F') ) )
		return false;

	// Verify Wave in Riff
	if(!(	(pRiffHeader->szRiffFormat[0] == 'W') &&
			(pRiffHeader->szRiffFormat[1] == 'A') &&
			(pRiffHeader->szRiffFormat[2] == 'V') &&
			(pRiffHeader->szRiffFormat[3] == 'E') ) )
		return false;
	
	return true;
}

// verifies fmt chunk. checks for 'fmt '
bool CWaveFileHandler::IsValidFmtChunk(void* pChunk)
{
	FMT_BLOCK *pFmtHeader = reinterpret_cast< FMT_BLOCK* >(pChunk);
	if(!(	(pFmtHeader->szFmtID[0] == 'f')&&
			(pFmtHeader->szFmtID[1] == 'm')&&
			(pFmtHeader->szFmtID[2] == 't')&&
			(pFmtHeader->szFmtID[3] == ' ') ) )
		return false;

	return true;
}

// checks for 'data' 
bool CWaveFileHandler::IsValidDataBlock(void* pData)
{
	DATA_BLOCK *pDataBlock = reinterpret_cast< DATA_BLOCK* >(pData);
	if(!(	(pDataBlock->szDataID[0] == 'd')&&
			(pDataBlock->szDataID[1] == 'a')&&
			(pDataBlock->szDataID[2] == 't')&&
			(pDataBlock->szDataID[3] == 'a') ) )	
		return false;

	return true;
}

void CWaveFileHandler::GetARiffChunk(RIFF_HEADER& rh)
{
	rh.dwRiffSize = sizeof(rh);
	rh.szRiffID[0] = 'R';
	rh.szRiffID[1] = 'I';
	rh.szRiffID[2] = 'F';
	rh.szRiffID[3] = 'F';

	// Lets add the wave tag id.
	rh.szRiffFormat[0] = 'W';
	rh.szRiffFormat[1] = 'A';
	rh.szRiffFormat[2] = 'V';
	rh.szRiffFormat[3] = 'E';

	rh.dwRiffSize = sizeof(rh);
}

void CWaveFileHandler::GetADataBlock(DATA_BLOCK& db)
{
	db.szDataID[0] = 'd';
	db.szDataID[1] = 'a';
	db.szDataID[2] = 't';
	db.szDataID[3] = 'a';
}

// returns detailed usage information .
const TCHAR * CWaveFileHandler::Usage(void)
{
	static const TCHAR *szUsage = "CWaveFileHandler class can be used for reading and writing to wave files. \n"\
		"You can use one instance of this class to open one file in read mode and one file in write mode at \n"\
		"the same time. use the OpenForRead and OpenForWrite methods respectively. The GetXX methods work on\n"\
		"the file that is open for read and the PutXX methods work on the file that is open for write\n"
		"INVOKING GetXX without opening a file for read or PutXX without opening a file for write is an error\n\n"\
		"E.g., to copy a wav file\n"\
		"CWaveFileHandler wfh;\n"\
		"wfh.OpenForRead(szBuf1); wfh.OpenForWrite(szBuf2);\n\n"\
		"BYTE * pRiff = wfh.GetRiff(dwRiffSize);\n"\
		"wfh.PutRiff(pRiff,dwRiffSize);\n"\
		"BYTE * pFmt = wfh.GetFmt(dwFmtsize);\n"\
		"wfh.PutFmt(pFmt,dwFmtsize);\n"\
		"BYTE * pData = wfh.GetData(dwDatasize);\n"\
		"wfh.PutData(pData,dwDatasize);\n\n"\
		"If the data already contains a data block, then just invoke putData. otherwise,\n"\
		"ideal usage would be like this:\n"\
		"1. DATA_BLOCK db; CWaveFileHandler::GetADataBlock(db);\n"\
		"2. wfh.PutData(&db,sizeof(db));\n"\
		"3. Invoke PutRawData as many times as you want with your raw wave data after this.\n";
		
		
		return szUsage;
}

// closes the file that was opened for reading
void CWaveFileHandler::CloseReader(void)
{
	InitMembers(READ);
}

// Closes the file that was opened for writing
void CWaveFileHandler::CloseWriter(void)
{
	InitMembers(WRITE);
}

// Closes all open files
void CWaveFileHandler::CloseAll(void)
{
	CloseReader();
	CloseWriter();
}

// just the wav format (raw fmt)
BYTE* CWaveFileHandler::GetRawFmt(DWORD& dwSize)
{
	dwSize = m_pFmtHeader->dwFmtSize;
	return reinterpret_cast< BYTE* >(& m_pFmtHeader->wavFormat);
}

// put a riff and a fmt block given just the raw fmt (wave format). used by album extractors.
void CWaveFileHandler::PutRawFmtAndHeader(BYTE* pRawFmt, DWORD dwFmtSize)
{
	try
	{
		// Lets add a RIFF.
		RIFF_HEADER rh;
		GetARiffChunk(rh);
		PutRiff(reinterpret_cast< BYTE* >(&rh),sizeof(rh));
		
		FMT_BLOCK fb;
		fb.dwFmtSize = dwFmtSize;
		fb.szFmtID[0] = 'f';
		fb.szFmtID[1] = 'm';
		fb.szFmtID[2] = 't';
		fb.szFmtID[3] = ' ';
		
		DWORD dwWritten=0;
		::WriteFile(m_hFile,&fb,sizeof(fb.dwFmtSize) + sizeof(fb.szFmtID),&dwWritten,NULL);
		m_dwWritten += dwWritten;
		::WriteFile(m_hFile,pRawFmt,dwFmtSize,&dwWritten,NULL);
		m_dwWritten += dwWritten;
	}
	catch(...)
	{
		InitMembers(WRITE);
		throw;
	}

}
