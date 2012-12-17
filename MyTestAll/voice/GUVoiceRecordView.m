//
//  ChatRoom_VoiceRecord.m
//  ZoukIn
//
//  Created by Jimmy Chew on 1/10/12.
//  Copyright (c) 2012 Zoukmobile. All rights reserved.
//

#import "GUVoiceRecordView.h"
#import <QuartzCore/QuartzCore.h>
# define showviewwidth 300

#define kTitleCancel @"取消"
#define kTitleDone @"保存"
#define kTitlePause @"暂停"
#define kTitleContine @"继续"
#define kTitleRecord @"录制"
#define kTitlePlay @"播放"


@implementation GUVoiceRecordView
@synthesize recordDelegate;
@synthesize recordDuration;

-(id)initWithRecordFile:(NSString*) fullPathName
{
    self = [super init];
    if(self)
    {
        _recordFullPathName = [fullPathName copy];
        
        self.frame = CGRectMake(0, 0, 320, 480);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        backView.backgroundColor=[UIColor blackColor];
        backView.alpha=0.5f;
        [self addSubview:backView];
        
        UIView *showView = [[UIView alloc] init];
        showView.frame = CGRectMake(0, 10, showviewwidth, 150);
        UIImageView *friendpic=[[UIImageView alloc]initWithFrame:CGRectMake(showviewwidth/2-35, 10, 70, 70)];
        [friendpic setImage:[UIImage imageNamed:@"Audio.png"]];
        [showView addSubview:friendpic];
        
        // 录制按钮
        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        recordBtn.frame = CGRectMake(50, 20, 50, 50);
        [recordBtn setTitle:kTitleRecord forState:UIControlStateNormal];
        [recordBtn addTarget:self action:@selector(recordbtnClidk:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:recordBtn];
    
        // 取消按钮
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(10 , 80 + 10, (showviewwidth-30)/2, 30);
        [btnCancel setTitle:kTitleCancel forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(canclebtnClidk:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btnCancel];
        
        // 保存按钮
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        _saveBtn.frame = CGRectMake(2*10 +((showviewwidth-30)/2), 80 + 10, (showviewwidth-30)/2, 30);
        [_saveBtn setTitle:kTitleDone forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(savebtnClidk:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setEnabled:NO];
        [showView addSubview:_saveBtn];
        
        showView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        
        showView.layer.cornerRadius = 8;
        showView.layer.borderWidth = 2;
        showView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        showView.layer.masksToBounds = YES;
        
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.3;
        animation.delegate = self;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        animation.values = values;
        [showView.layer addAnimation:animation forKey:nil];
        
        [self addSubview:showView];
        [showView release];
        
        showView.frame = CGRectMake(0, 0, showviewwidth, friendpic.frame.origin.y+friendpic.frame.size.height + 15+40);
        showView.center = self.center;
                
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


-(IBAction)recordbtnClidk:(UIButton *)sender{
    
    if (_recordState == enRecordStateStop) {
        [_audioSession setActive: YES error: nil];
        if (_audioRecorder) {
            [_audioRecorder prepareToRecord];
            _audioRecorder.meteringEnabled = YES;
            [_audioRecorder peakPowerForChannel:0];
            _levelTimer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
            [_audioRecorder record]; // 开始录制
            _saveBtn.enabled = YES;
        }
        _recordState = enRecordStateRecord;
        [sender setTitle:kTitlePause forState:UIControlStateNormal];
    }else if (_recordState == enRecordStateRecord){
        [_audioRecorder pause]; // 暂停
        _recordState = enRecordStatePause;
        [sender setTitle:kTitleContine forState:UIControlStateNormal];
        _saveBtn.enabled = YES;
    }else if (_recordState == enRecordStatePause){
        [_audioRecorder record]; // 恢复录制
        _recordState = enRecordStateRecord;
        [sender setTitle:kTitlePause forState:UIControlStateNormal];
        _saveBtn.enabled = YES;
    }
}


#pragma mark AVAudioRecorderDelegate method
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [_audioSession setActive: NO error: nil];
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
}

-(void)levelTimerCallback:(NSTimer *)timer{
    if (_recordState == enRecordStateRecord) {
        [_audioRecorder updateMeters];
        NSLog(@"1 %f 2%f",[_audioRecorder averagePowerForChannel:0],[_audioRecorder peakPowerForChannel:0]);
    }
}

-(IBAction) canclebtnClidk:(UIButton *)sender{
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
    if (_recordState == enRecordStateRecord || _recordState == enRecordStatePause) {
        [_audioSession setActive: NO error: nil];
        [_audioRecorder stop]; // 停止录制
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    [self hiddenAlert];
}

-(IBAction)savebtnClidk:(UIButton *)sender{
    if (_levelTimer != nil) {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
    if (_recordState == enRecordStateRecord || _recordState == enRecordStatePause) {
        [_audioSession setActive: NO error: nil];
        [_audioRecorder stop]; // 停止录制
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    [self hiddenAlert];
    
    if (self.recordDelegate != nil) {
        [self.recordDelegate recordDone:_recordFullPathName result:YES];
    }
}

-(void)hiddenAlert
{
    [_audioSession setActive: NO error: nil];
    [self dismissMyAlertView];
}

-(void)dismissMyAlertView
{
    [UIView beginAnimations:@"hidden" context:nil];
    self.alpha = 0;
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self removeFromSuperview];
}

-(void)dealloc
{
    [_recordFullPathName release];
    [super dealloc];
}

@end