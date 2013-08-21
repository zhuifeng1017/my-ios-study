//
//  MZVoiceViewController.m
//  MyTestAll
//
//  Created by uistrong on 12-12-13.
//
//

#import "MZVoiceViewController.h"
#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface MZVoiceViewController ()

@end

@implementation MZVoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _playState = enPlayStateStop;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnPlay:nil];
    [self setBtnRecord:nil];
    [super viewDidUnload];
}

- (IBAction)actionRecord:(id)sender {
    if (audioPlayer != nil) {
        [audioPlayer stop];
        audioPlayer = nil;
        _playState = enPlayStateStop;
        [self.btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    }
    NSString *fullPathName = [kDocuments stringByAppendingString:@"/record.mp3"];
    GUVoiceRecordView *vr=[[GUVoiceRecordView alloc] initWithRecordFile:fullPathName];
    [self.view addSubview:vr];
}

- (IBAction)actionPlay:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (_playState == enPlayStateStop) {
        if (audioPlayer == nil) {
            if (_recordFileFullPathName == nil) {
                _recordFileFullPathName = [kDocuments stringByAppendingString:@"/record.mp3"];
            }
            NSError *error;
            NSURL *url = [NSURL fileURLWithPath:_recordFileFullPathName];
            audioPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (audioPlayer == nil) {
                NSLog(@"error %@", [error description]);
                return;
            }
            audioPlayer.volume = 0.5;
            audioPlayer.meteringEnabled=NO;
            audioPlayer.numberOfLoops= 0;
            audioPlayer.delegate=self;
        }
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error: nil];
        [audioPlayer play];  // play
        _playState = enPlayStatePlay;
        [btn setTitle:@"Pause" forState:UIControlStateNormal];
        
    }else if (_playState == enPlayStatePlay){
        [audioPlayer pause]; // pause
        _playState = enPlayStatePause;
        [btn setTitle:@"Contine" forState:UIControlStateNormal];
    }else if (_playState == enPlayStatePause){
        [audioPlayer play]; // resume
        _playState = enPlayStatePlay;
        [btn setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [audioPlayer stop];
    audioPlayer = nil;
    _playState = enPlayStateStop;
    [self.btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    NSLog(@"play over");
}

#pragma mark GUVoiceRecordDoneDelegate method
- (void) recordDone:(NSString*) recordFullPathName result:(BOOL) result
{
    _recordFileFullPathName = [recordFullPathName copy];
}

@end
