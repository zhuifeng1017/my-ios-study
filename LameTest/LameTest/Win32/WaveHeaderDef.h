typedef  struct  
{   
	u_long     dwSize ;  
	u_short    wFormatTag ;  
	u_short    wChannels ;  
	u_long     dwSamplesPerSec ;  
	u_long     dwAvgBytesPerSec ;  
	u_short    wBlockAlign ;  
	u_short    wBitsPerSample ;  
} WAVEFORMAT ;  

typedef  struct  
{   
	char        RiffID [4] ;  //0 ¡®riff¡¯
	u_long      RiffSize ;  	//4
	char        WaveID [4] ;  	//8 ¡®wav¡¯

	char        FmtID  [4] ;  //12	¡®fmt¡¯
	u_long      FmtSize ;  	//16
	u_short     wFormatTag ;  //18
	u_short     nChannels ;  	// 20
	u_long      nSamplesPerSec ;  //24
	u_long      nAvgBytesPerSec ;  //28
	u_short     nBlockAlign ;  // 32
	u_short     wBitsPerSample ;  // 36 

	char        DataID [4] ;  //40 ¡®data¡¯
	u_long      nDataBytes ;  //44
} WAVE_HEADER ;	// 44 byte

static  WAVE_HEADER  waveheader =  
{ 
{ 'R', 'I', 'F', 'F' },  
0,  
{ 'W', 'A', 'V', 'E' },  
{ 'f', 'm', 't', ' ' },  
16,                             /* FmtSize*/  
PCM_WAVE_FORMAT,                        /* wFormatTag*/  
0,                              /* nChannels*/  
0,  
0,  
0,  
0,  
{ 'd', 'a', 't', 'a' },  
0  
} ; /* waveheader*/  