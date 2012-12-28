//
//  GUVoicePlayer.h
//  MyTestAll
//
//  Created by uistrong on 12-12-17.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum{
    enPlayStateStop = 0,
    enPlayStatePlay,
    enPlayStatePause,
}enPlayState;

@protocol GUVoicePlayerDelegate <NSObject>
@optional
- (void) playOverNotify;
@end


@interface GUVoicePlayer : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer * _audioPlayer;
    enPlayState _playState;
}

- (id) init;
- (void) play;
- (void) stop;
- (enPlayState) state;

@property (strong,nonatomic) NSString *recordFileFullPathName;
@property (assign, nonatomic) id <GUVoicePlayerDelegate> playerDelegate;

@end
