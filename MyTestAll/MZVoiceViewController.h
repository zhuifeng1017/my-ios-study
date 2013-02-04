//
//  MZVoiceViewController.h
//  MyTestAll
//
//  Created by uistrong on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import "GUVoiceRecordView.h"
#import "GUVoiceRecorder.h"


@interface MZVoiceViewController : UIViewController </*GUVoiceRecordDoneDelegate,*/GUVoiceRecorderDelegate,AVAudioPlayerDelegate, UIAlertViewDelegate>
{
    NSString *_recordFileFullPathName;
    AVAudioPlayer * audioPlayer;
    enPlayState _playState;
    GUVoiceRecorder *_recoder;
    UIAlertView *_alertView;
    UIButton *_alertViewBtnRecord;

    UIAlertView *_processAlertView;
}

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

- (IBAction)actionRecord:(id)sender;
- (IBAction)actionPlay:(id)sender;
- (IBAction)actionThreadTest:(id)sender;

@end
