//
//  MZViewController.h
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface MZViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{
    NSThread *_thrProducer;
    BOOL _thrProducerRunning;
}
- (IBAction)actionThread:(id)sender;
- (IBAction) actionThreadStop:(id)sender;

- (IBAction) actionSMS:(id)sender;

//@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UIButton *btnSMS;



- (IBAction)actionTest:(id)sender;

@end
