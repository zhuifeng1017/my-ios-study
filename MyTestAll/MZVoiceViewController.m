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
    
//    NSString *fullPathName = [kDocuments stringByAppendingString:@"/record.caf"];
//    GUVoiceRecordView *vr=[[GUVoiceRecordView alloc] initWithRecordFile:fullPathName];
 //   [self.view addSubview:vr];
 //   GUVoiceRecorder *recoder = [[GUVoiceRecorder alloc] initWithRecordFile:fullPathName];
    
    [self doAlertView:sender];
}

- (IBAction)actionPlay:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (_playState == enPlayStateStop) {
        if (audioPlayer == nil) {
            if (_recordFileFullPathName == nil) {
                _recordFileFullPathName = [kDocuments stringByAppendingString:@"/record.caf"];
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

- (IBAction)actionThreadTest:(id)sender {
    [self createAlertView];
    [_processAlertView setTitle:@"正在运行中...."];
    [_processAlertView show];
    
    _threadRunning = YES;
#if 0
    [NSThread detachNewThreadSelector:@selector(threadEntity:) toTarget:self withObject:nil];
#else
    [self performSelectorInBackground:@selector(threadEntity:) withObject:nil];
    
//    NSThread *thr = [[NSThread alloc] initWithTarget:self selector:@selector(threadEntity:) object:nil];
//    [thr start];
#endif
    
    // NSRunLoop
    while (_threadRunning) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    [self hideAlertView:nil];
}

- (void) threadEntity:(id) param{
    if (_threadRunning) {
        int nCount = 5;
        while (nCount--) {
            NSLog(@"thread run : %d", nCount);
            sleep(1);
        }
    }
#if 0
    [self performSelectorOnMainThread:@selector(threadOver:) withObject:nil waitUntilDone:NO];
#endif
    
    _threadRunning = NO;
}

- (void) createAlertView{
    if (_processAlertView == nil) {
        _processAlertView = [[UIAlertView alloc]
                             initWithTitle:@""
                             message:nil
                             delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
        UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 65, 20, 20)];
        activity.tag = 0xFF;
        [_processAlertView addSubview:activity];
    }
    UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[_processAlertView viewWithTag:0xFF];
    if (![activity isAnimating]) {
        [activity startAnimating];
    }
}

- (void) hideAlertView:(id) param{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[_processAlertView viewWithTag:0xFF];
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
    [_processAlertView dismissWithClickedButtonIndex:0 animated:YES];
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

- (IBAction)doAlertView:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"hello"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"保存",
                              nil];

    if (_alertViewBtnRecord == nil) {
        _alertViewBtnRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _alertViewBtnRecord.frame = CGRectZero;
        [_alertViewBtnRecord addTarget:self action:@selector(doRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    _alertViewBtnRecord.enabled = YES;
    [_alertViewBtnRecord setTitle:@"录音" forState:UIControlStateNormal];
    [alertView addSubview:_alertViewBtnRecord];
    [alertView show];
    _alertView  = alertView;
}

- (IBAction)doRecord:(id)sender{
    NSLog(@"Record....");
    if (_recoder == nil) {
        NSString *fullPathName = [kDocuments stringByAppendingString:@"/record.caf"];
        _recoder = [[GUVoiceRecorder alloc] initWithRecordFile:fullPathName];
        _recoder.recordDuration = 5;
        _recoder.recordDelegate = self;
    }
    enRecordState state = [_recoder actionRecord];
    switch (state) {
        case enRecordStateRecord:
            [(UIButton*)sender setTitle:kTitlePause forState:UIControlStateNormal];
            [self enableSaveBtn:YES];
            break;
        case enRecordStatePause:
            [(UIButton*)sender setTitle:kTitleContine forState:UIControlStateNormal];
            [self enableSaveBtn:YES];
            break;
        case enRecordStateStop:
            [(UIButton*)sender setTitle:@"已结束" forState:UIControlStateNormal];
            [(UIButton*)sender setEnabled:NO];
            break;
    }
}

- (void) enableSaveBtn:(BOOL) enable{
    for (UIView *v in _alertView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIButton")]) {
            UIButton *button = (UIButton *)v;
           if([[button titleForState:UIControlStateNormal] compare:@"保存"] == NSOrderedSame){
                button.enabled = enable;
                break;
            }
        }
    }
}

- (void) recordTimeOver{
    _alertViewBtnRecord.enabled = NO;
    [_alertViewBtnRecord setTitle:@"已完成" forState:UIControlStateNormal];
}

#pragma mark -- UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [_recoder discardRecord];
    }else if (buttonIndex == 1){
        _recordFileFullPathName = [_recoder saveRecord];
    }
    _recoder = nil;
    _alertView = nil;
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
    CGRect frame = alertView.frame;
    frame.size.height = 170;
    alertView.frame = frame;
    
    for (UIView *v in alertView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIButton")]) {
            UIButton *button = (UIButton *)v;
            NSLog(@"btn tag : %d", button.tag);
            if ([[button titleForState:UIControlStateNormal] compare:@"录音"] == NSOrderedSame) {
                button.frame = CGRectMake(30,30, 60, 60);
            }else if ([[button titleForState:UIControlStateNormal] compare:@"取消"] == NSOrderedSame){
                button.frame = CGRectMake(11, 101, 127, 43);
            }else if([[button titleForState:UIControlStateNormal] compare:@"保存"] == NSOrderedSame){
                button.frame = CGRectMake(146, 101, 127, 43);
                button.enabled = NO;
            }
        }
    }

    NSLog(@"willPresentAlertView");
}

@end
