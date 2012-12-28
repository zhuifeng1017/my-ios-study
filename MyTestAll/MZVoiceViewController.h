//
//  MZVoiceViewController.h
//  MyTestAll
//
//  Created by uistrong on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import "GUVoiceRecordView.h"

@class GUVoiceRecorder;

@interface MZVoiceViewController : UIViewController </*GUVoiceRecordDoneDelegate,*/AVAudioPlayerDelegate, UIAlertViewDelegate>
{
    NSString *_recordFileFullPathName;
    AVAudioPlayer * audioPlayer;
    enPlayState _playState;
    GUVoiceRecorder *_recoder;
    UIAlertView *_alertView;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

- (IBAction)actionRecord:(id)sender;
- (IBAction)actionPlay:(id)sender;
@end
