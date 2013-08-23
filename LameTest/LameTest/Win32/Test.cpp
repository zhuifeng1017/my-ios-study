#include "StdAfx.h"
#include "WaveFileHandler.h"


int main(){

	CWaveFileHandler wfh;
	wfh.OpenForRead("RecordedFile.wav");
	wfh.CloseAll();

	printf("exit.....");
	getchar();
	return 0;
}