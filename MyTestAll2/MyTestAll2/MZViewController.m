//
//  MZViewController.m
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import "MZViewController.h"
#import "MZTT001ViewController.h"

@interface MZViewController ()

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *bubble = [UIImage imageNamed:@"textinput.png"];
    NSLog(@"%f, %f", bubble.size.width, bubble.size.height);
    
    // 拉伸
    bubble = [bubble stretchableImageWithLeftCapWidth:bubble.size.width*0.5 topCapHeight:bubble.size.height*0.5];
    //[self.imgView setImage:bubble];
    [self.btn setBackgroundImage:bubble forState:UIControlStateNormal];
    
    
    UINavigationBar *navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    //navBar.barStyle = UIBarStyleBlack;
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbak.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *navItem = [[[UINavigationItem alloc]initWithTitle:@"XXX"] autorelease];
    [navBar setItems:[NSArray arrayWithObject:navItem] animated:NO];
    [self.view addSubview:navBar];
    
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)]autorelease];
    label.text = @"I am a label";
    [self.view addSubview:label];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    NSLog(@"MZViewController dealloc");
    [super dealloc];
}

- (IBAction)actionThread:(id)sender {
    if (_thrProducer == nil) {
        _thrProducer = [[NSThread alloc] initWithTarget:self selector:@selector(producerThread:) object:self];
    }
    if (![_thrProducer isExecuting]) {
        _thrProducerRunning = YES;
        [_thrProducer start];
    }
    
}

- (IBAction)actionThreadStop:(id)sender {
    
    if (_thrProducer) {
        if ([_thrProducer isExecuting]) {
            _thrProducerRunning = NO;
            int nCount = 1000;
            while (![_thrProducer isFinished] && nCount--) {
                usleep(1000);
            }
            
            if (!nCount) {
                [NSThread exit];
            }
        }
        
        [_thrProducer release];
        _thrProducer = nil;
        
        NSLog(@"thread is stop");
    }else{
       NSLog(@"thread is not create"); 
    }
}

- (void) producerThread:(id) param{
    static int i = 0;
    while (_thrProducerRunning) {
        NSLog(@"%d", i++);
        sleep(1);
    }
}

- (IBAction) actionSMS:(id)sender{
    [self showSMSPicker];
}

-(void)showSMSPicker{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else {
        
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    NSString *smsBody =[NSString stringWithFormat:@"我分享了文件给您，地址是%@",@"我分享了文件给您，地址是我分享了文件给您，地址是我分享了文件给您，地址是我分享了文件给您，地址是我分享了文件给您，地址是"];
    picker.body=smsBody;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark -
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:YES];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            break;
        case MessageComposeResultSent:
        {
            //do something
        }
            break;
        default:
            break;
    }
}

- (IBAction)actionTest:(id)sender{
    MZTT001ViewController *VC = [[MZTT001ViewController alloc] initWithNibName:@"MZTT001ViewController" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:navVC animated:YES completion:NULL];
    [VC release];
}

@end
