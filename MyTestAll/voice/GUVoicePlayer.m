//
//  GUVoicePlayer.m
//  MyTestAll
//
//  Created by uistrong on 12-12-17.
//
//

#import "GUVoicePlayer.h"

@implementation GUVoicePlayer

- (id) init{
    self = [super init];
    if (self) {
        _playState = enPlayStateStop;
        _audioPlayer = nil;
    }
    return self;
}

- (void) play{
    if (_playState == enPlayStateStop) {
        if (_audioPlayer == nil) {
            NSError *error;
            NSURL *url = [NSURL fileURLWithPath:self.recordFileFullPathName];
            _audioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (_audioPlayer == nil) {
                NSLog(@"error %@", [error description]);
                return;
            }
            _audioPlayer.volume = 0.5;
            _audioPlayer.meteringEnabled=NO;
            _audioPlayer.numberOfLoops= 0;
            _audioPlayer.delegate=self;
        }
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error: nil];
        [_audioPlayer play];  // play
        _playState = enPlayStatePlay;
    }else if (_playState == enPlayStatePlay){
        [_audioPlayer pause]; // pause
        _playState = enPlayStatePause;
    }else if (_playState == enPlayStatePause){
        [_audioPlayer play]; // resume
        _playState = enPlayStatePlay;
    }
}

- (void) stop{
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        [_audioPlayer release];
        _audioPlayer = nil;
        _playState = enPlayStateStop;
    }
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player) {
        [_audioPlayer stop];
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    _playState = enPlayStateStop;
    NSLog(@"play over");
    
    if (self.playerDelegate != nil) {
        [self.playerDelegate playOverNotify];
    }
}

- (enPlayState) state{
    return _playState;
}

@end
