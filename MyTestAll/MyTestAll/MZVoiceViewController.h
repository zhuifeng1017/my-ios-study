//
//  MZVoiceViewController.h
//  MyTestAll
//
//  Created by uistrong on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import "GUVoiceRecordView.h"

typedef enum{
    enPlayStateStop = 0,
    enPlayStatePlay,
    enPlayStatePause,
}enPlayState;

@interface MZVoiceViewController : UIViewController <GUVoiceRecordDoneDelegate,AVAudioPlayerDelegate>
{
    NSString *_recordFileFullPathName;
    AVAudioPlayer * audioPlayer;
    enPlayState _playState;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

- (IBAction)actionRecord:(id)sender;
- (IBAction)actionPlay:(id)sender;
@end
