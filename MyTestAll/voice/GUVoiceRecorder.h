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

-(id)initWithRecordFile:(NSString*) fullPathName;

@end
