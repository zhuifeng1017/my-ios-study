    //
//  GUVoiceRecorder.m
//  MyTestAll
//
//  Created by uistrong on 12-12-28.
//
//

#import "GUVoiceRecorder.h"

@implementation GUVoiceRecorder
-(id)initWithRecordFile:(NSString*) fullPathName
{
    self = [super init];
    if(self)
    {
        _recordFullPathName = [fullPathName copy];
        self.recordDuration = 300;
        

        _audioSession= [AVAudioSession sharedInstance];
        _audioSession.delegate = self;
        
        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                nil];
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
        
        NSURL *url = [NSURL fileURLWithPath:_recordFullPathName];
		NSError *error;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        _audioRecorder.delegate = self;
        
        _recordState = enRecordStateStop;
    }
    return self;
}

- (enRecordState) actionRecord{
    if (_recordState == enRecordStateStop) {
        [_audioSession setActive: YES error: nil];
        if (_audioRecorder) {
            [_audioRecorder prepareToRecord];
            _audioRecorder.meteringEnabled = YES;
            [_audioRecorder recordForDuration:self.recordDuration];
            [_audioRecorder peakPowerForChannel:0];
            _levelTimer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
            [_audioRecorder record]; // 开始录制
        }
        _recordState = enRecordStateRecord;
    }else if (_recordState == enRecordStateRecord){
        [_audioRecorder pause]; // 暂停
        _recordState = enRecordStatePause;
    }else if (_recordState == enRecordStatePause){
        [_audioRecorder record]; // 恢复录制
        _recordState = enRecordStateRecord;
    }
    return _recordState;
}

- (NSString *) saveRecord{
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
    
    [_audioSession setActive: NO error: nil];
    if (_recordState == enRecordStateRecord || _recordState == enRecordStatePause) {
        [_audioRecorder stop]; // 停止录制
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    _recordState = enRecordStateStop;
    return _recordFullPathName;
}

- (void) discardRecord{
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
    if (_recordState == enRecordStateRecord || _recordState == enRecordStatePause) {
        [_audioSession setActive: NO error: nil];
        [_audioRecorder stop]; // 停止录制
        assert([_audioRecorder deleteRecording]);// 删除录制文件
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    _recordState = enRecordStateStop;
}

#pragma mark AVAudioRecorderDelegate method
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [_audioSession setActive: NO error: nil];
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
    
    if (_audioRecorder != nil) {
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    _recordState = enRecordStateStop;
}

-(void)levelTimerCallback:(NSTimer *)timer{
    if (_recordState == enRecordStateRecord) {
        [_audioRecorder updateMeters];
        NSLog(@"1 %f 2%f",[_audioRecorder averagePowerForChannel:0],[_audioRecorder peakPowerForChannel:0]);
    }
}

@end
