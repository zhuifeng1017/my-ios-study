//
//  GUVoiceRecorder.h
//  MyTestAll
//
//  Created by uistrong on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include "VoiceDefine.h"

@protocol GUVoiceRecorderDelegate <NSObject>
@required
- (void) recordTimeOver;

@end

@interface GUVoiceRecorder : NSObject<AVAudioRecorderDelegate,AVAudioSessionDelegate>
{
@private
    AVAudioSession *_audioSession;
    AVAudioRecorder *_audioRecorder;
    NSString *_recordFullPathName;
    NSTimer *_levelTimer;
    enRecordState _recordState;
}

- (enRecordState) actionRecord;
- (NSString *) saveRecord;
- (void) discardRecord;

@property (assign, nonatomic) int recordDuration;
@property (assign, nonatomic) id<GUVoiceRecorderDelegate> recordDelegate;

-(id)initWithRecordFile:(NSString*) fullPathName;

@end
