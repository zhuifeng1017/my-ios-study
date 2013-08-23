//////////////////////////////////////////////////////////////////////////////////////////////////////////
// CWaveFileHandler , helper class for handling wav files. Use this class to read/write wav files
// internally, this class makes use of memory mapped files for doing reads. 
// 
// PLEASE NOTE : the PutRiff, PutFmt and PutData calls MUST be made in this order only. Invoking
// PutRiff after PutFmt or PutData may corrupt the wav file. this limitation will be addressed in
// the next revision.
//
// All methods would throw a const tchar* exception.
//
// This class can  handle one file in read mode and one in write mode at the same time.
//
// -Vinayak Raghuvamshi
//////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma once

class CMemoryMapper; // declared in MemoryMapper.h

struct WAVE_FORMAT
{
	WORD	wFormatTag;
	WORD	wChannels;	// 通道 （eg：2 （双通道））
	DWORD	dwSamplesPerSec; // 采样率 44100
	DWORD	dwAvgBytesPerSec;		// 每秒需要的字节数 (dwSamplesPerSec * wBlockAlign)
	WORD	wBlockAlign;	// 每个采样需要字节数 （eg：16bit=4byte）
	WORD	wBitsPerSample;	// 每个采样需要的bit数（采样位数，eg：16）
};	// 16byte

struct RIFF_HEADER
{
	TCHAR	szRiffID[4];		// 'R','I','F','F'
	DWORD	dwRiffSize;
	TCHAR	szRiffFormat[4];	// 'W','A','V','E'
};

struct FMT_BLOCK
{
	TCHAR		szFmtID[4];	// 'f','m','t',' '
	DWORD		dwFmtSize;
	WAVE_FORMAT	wavFormat;
};

struct DATA_BLOCK
{
	TCHAR	szDataID[4];	// 'd','a','t','a'
	DWORD	dwDataSize;
};

class CWaveFileHandler
{
public:
	CWaveFileHandler(void);
	virtual ~CWaveFileHandler(void);
	// Opens a wav file for reading. fails if not exists. throws tchar * exception
	void OpenForRead(const TCHAR* szFile);
	// opens wav for writing. overwrites if specified. throws tchar* exception
	void OpenForWrite(const TCHAR* szFile, bool bOverWrite);
	// Gets RIFF chunk. NULL if not present
	BYTE* GetRiff(DWORD& dwRiffChunckSize);
	// Gets the fmt block chunck. 
	BYTE* GetFmt(DWORD& dwSize);
	// Gets the actual data block ptr. actually, a ptr to the map view of this wav file.
	BYTE* GetData(DWORD& dwSize);
	// writes the riff header to the wav file.
	void PutRiff(BYTE* pRiff, DWORD dwSize);
	// writes the fmt block
	void PutFmt(BYTE* pFmt, DWORD dwSize);
	// writes the header. adds a riff if absent in the header. use this version if u are not sure what ur header contains.
	void PutHeader(BYTE* pHeader, DWORD dwSize);
	// writes the actual data. A user can set up the riff and fmt chunks and then invoke putdata many times
	// we will keep appending the data bytes and modifying the size in the riff header after each data block
	// write is done.
	void PutData(BYTE* pData, DWORD dwSize);

protected:

protected:
	// once the wav has been opened for read, subclasses can directly access the individual chunks.
	BYTE			*m_pStartOfData;	// start of the actual Wave Data
	RIFF_HEADER     *m_pRiffHeader;		// start of the Riff chunk
	FMT_BLOCK		*m_pFmtHeader;		// start of the Fmt chunk
	DATA_BLOCK		*m_pDataBlock;		// start of the Data header chunk

private:
	CMemoryMapper	*m_pMemoryMap;	// The underlying Memory map handler
	HANDLE			m_hFile;		// File handle, used for write mode (openForWrite)
	DWORD			m_dwWritten;	// Track number of bytes written
	enum eInitMode{READ,WRITE,BOTH};
	// initialize all member vars
	void InitMembers(eInitMode eMode);
public:
	// just checks for the 'RIFF' and 'WAVE' tags.
	static bool IsValidRiffHeader(void* pHeader);
	// verifies fmt chunk. checks for 'fmt '
	static bool IsValidFmtChunk(void* pChunk);
	// checks for 'data' 
	static bool IsValidDataBlock(void* pData);
	// generate default values for a riff header chunk
	static void GetARiffChunk(RIFF_HEADER& rh);
	// initialize a datablock with defaults
	static void GetADataBlock(DATA_BLOCK& db);
	// Gets the raw data, i.e, without the datablock header.
	BYTE* GetRawData(DWORD& dwSize);
	// puts raw data. i.e data without datablock. if data contains data block it will be stripped out
	void PutRawData(BYTE* pData, DWORD dwSize);
	// returns detailed usage information .
	static const TCHAR * Usage(void);
	// closes the file that was opened for reading
	void CloseReader(void);
	// Closes the file that was opened for writing
	void CloseWriter(void);
	// Closes all open files
	void CloseAll(void);
	// just the wav format (raw fmt)
	BYTE* GetRawFmt(DWORD& dwSize);
	// put a riff and a fmt block given just the raw fmt (wave format). used by album extractors.
	void PutRawFmtAndHeader(BYTE* pRawFmt, DWORD dwFmtSize);
};
