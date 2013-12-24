//
//  MZAppDelegate.m
//  LameTest
//
//  Created by uistrong on 13-8-22.
//  Copyright (c) 2013年 uistrong. All rights reserved.
//

#import "MZAppDelegate.h"
#import "MZViewController.h"
#import "lame.h"

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation MZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    int read, write;
    
    NSString *cafFile = [kDocuments stringByAppendingFormat:@"/record.wav"];
    NSString *mp3File = [kDocuments stringByAppendingFormat:@"/file.mp3"];
    
    FILE *pcm = fopen(cafFile.UTF8String, "rb");
    FILE *mp3 = fopen(mp3File.UTF8String, "wb");
    
    const int PCM_SIZE = 8192;
    const int MP3_SIZE = 8192;
    
    short int pcm_buffer[PCM_SIZE*2];   // 双通道
    unsigned char mp3_buffer[MP3_SIZE];
    
    lame_t lame = lame_init();
    lame_set_in_samplerate(lame, 44100);    // 采样率
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);
    
    fseek(pcm, 44, SEEK_CUR); // skip wav header,44 byte
    do {
        read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);   // 读取pcm数据，left channel，right channel
        if (read == 0)  // 转换结束
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        else
            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);   // 转换
        fwrite(mp3_buffer, write, 1, mp3);  // 写文件
    } while (read != 0);
    
    lame_close(lame);
    fclose(mp3);
    fclose(pcm);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MZViewController alloc] initWithNibName:@"MZViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
