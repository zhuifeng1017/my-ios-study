//
//  MZTestMiniZipViewController.m
//  MyTestAll
//
//  Created by uistrong on 12-10-24.
//
//

#import "MZTestMiniZipViewController.h"
#import "LibMinizip/ZipArchive/ZipArchive.h"

@interface MZTestMiniZipViewController ()

@end

@implementation MZTestMiniZipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) didReceiveMemoryWarning
{
    NSLog(@"MemoryWarning %@", [[self class] description]);
    [super didReceiveMemoryWarning];
    // only want to do this on iOS 6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //  Don't want to rehydrate the view if it's already unloaded
        BOOL isLoaded = [self isViewLoaded];
        
        //  We check the window property to make sure that the view is not visible
        if (isLoaded && self.view.window == nil) {
            
            //  Give a chance to implementors to get model data from their views
            [self performSelectorOnMainThread:@selector(viewWillUnload)
                                   withObject:nil
                                waitUntilDone:YES];
            
            //  Detach it from its parent (in cases of view controller containment)
            [self.view removeFromSuperview];
            self.view = nil;    //  Clear out the view.  Goodbye!
            
            //  The view is now unloaded...now call viewDidUnload
            [self performSelectorOnMainThread:@selector(viewDidUnload)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
}

- (IBAction)doTestMinizip:(id)sender {
    NSLog(@"%@", NSHomeDirectory());
    ZipArchive *archive = [[ZipArchive alloc] init];
    [archive CreateZipFile2:@"/Users/uistrong/trip.zip"];
    [archive addFileToZip:@"/Users/uistrong/1.trip" newname:@"1.trip"];
    [archive CloseZipFile2];
    

#if 0
    const char *filePath = "/Users/uistrong/h.zip";
    BOOL bRet = [archive UnzipOpenFile:[NSString stringWithUTF8String:filePath]];
    NSLog(@"zip open ret %d", bRet);
    if (bRet) {
        bRet = [archive UnzipFileTo:@"/Users/uistrong" overWrite:YES];
        NSLog(@"unzip ret %d", bRet);
    }
    [archive UnzipCloseFile];
#endif
    
    
}

- (IBAction)doTest2:(id)sender {
#if 0
    NSString  = self.textField.text;  // 此时_str和textfile.text 指向同一个NSString对象@“aaaa”
    NSLog(@"%@", _str);
    
    self.textField.text = @"bbbb"; //  textfile.text指向@"aaaa", _str指向@“aaaa”
    [self.textField setNeedsDisplay];
    
    NSLog(@"str:%@, textField:%@", _str, self.textField.text);
#endif

    NSString *str = self.textField.text;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[docPath stringByAppendingPathComponent:str] stringByAppendingPathExtension:@"txt"];
    const char *pStr = filePath.UTF8String;
    printf("%s\n", pStr);
    FILE *pF = fopen(filePath.UTF8String, "wb");
    
    fwrite("123", 3, 1, pF);
    fclose(pF);
    
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
