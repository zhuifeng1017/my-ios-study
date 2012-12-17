//
//  ChatRoom_VoiceRecord.h
//  ZoukIn
//
//  Created by Jimmy Chew on 1/10/12.
//  Copyright (c) 2012 Zoukmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum{
    enRecordStateStop = 0,
    enRecordStateRecord,
    enRecordStatePause,
}enRecordState;

@protocol GUVoiceRecordDoneDelegate <NSObject>
@required
- (void) recordDone:(NSString*) recordFullPathName result:(BOOL) result;
@end

@interface GUVoiceRecordView : UIView<AVAudioRecorderDelegate,AVAudioSessionDelegate>{
@private
    AVAudioSession *_audioSession;
    AVAudioRecorder *_audioRecorder;
    NSString *_recordFullPathName;
    NSTimer *_levelTimer;
    enRecordState _recordState;
    
    UIButton *_saveBtn;
}

@property (assign, nonatomic) id<GUVoiceRecordDoneDelegate> recordDelegate;
@property (assign, nonatomic) int recordDuration;

-(id)initWithRecordFile:(NSString*) fullPathName;

-(void)dismissMyAlertView;
-(void)hiddenAlert;
@end