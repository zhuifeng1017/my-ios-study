//
//  VoiceDefine.h
//  MyTestAll
//
//  Created by uistrong on 12-12-28.
//
//

#ifndef MyTestAll_VoiceDefine_h
#define MyTestAll_VoiceDefine_h

typedef enum{
    enPlayStateStop = 0,
    enPlayStatePlay,
    enPlayStatePause,
}enPlayState;

typedef enum{
    enRecordStateStop = 0,
    enRecordStateRecord,
    enRecordStatePause,
}enRecordState;

#define kTitleCancel @"取消"
#define kTitleDone @"保存"
#define kTitlePause @"暂停"
#define kTitleContine @"继续"
#define kTitleRecord @"录制"
#define kTitlePlay @"播放"

#endif
