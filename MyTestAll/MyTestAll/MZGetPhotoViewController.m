//
//  MZGetPhotoViewController.m
//  MyTestAll
//
//  Created by uistrong on 12-11-6.
//
//

#import "MZGetPhotoViewController.h"

@interface MZGetPhotoViewController ()

@end

@implementation MZGetPhotoViewController

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
    self.myTextFiled.delegate = self;
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

- (IBAction)doStartCamera:(id)sender {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    //pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerC animated:YES completion:NULL];
}

- (IBAction)doEnumPhotos:(id)sender {
    // 遍历获取gpx文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSMutableArray *arrJpgFile = [[NSMutableArray alloc] init];
    
    NSString *thumbPath = NSHomeDirectory();
    NSError *err = [[NSError alloc] init];
    NSArray *arrFiles = [fileManager contentsOfDirectoryAtPath:thumbPath error:&err];
   // NSLog(@"%@",[err localizedDescription]);
    
    if (arrFiles != nil) {
        for(id fileName in arrFiles){
            NSLog(@"%@", fileName);
            if([[[fileName pathExtension] lowercaseString] isEqualToString:@"jpg"]){
                NSDictionary *attribs = [fileManager attributesOfItemAtPath:
                                         [thumbPath stringByAppendingPathComponent:fileName] error:nil];
                if ([[attribs objectForKey:@"NSFileType"] isEqualToString:@"NSFileTypeRegular"]) {
                    NSLog(@"%@", fileName);
                }
            }
        }
    }
    
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 添加gps元数据
    NSDictionary *metaDict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSArray *arr = [metaDict allKeys];
    for (NSString *strKey in arr) {
        NSLog(@"meta key: %@", strKey);
    }
    
    NSDictionary *exifMetadata = [metaDict objectForKey:@"{Exif}"];
    NSArray *arr1 = [exifMetadata allKeys];
    for (NSString *strKey in arr1) {
        NSLog(@"Exif key: %@", strKey);
    }
    
    NSDictionary *tiffMetadata = [metaDict objectForKey:@"{TIFF}"];
    
    NSArray *arr2 = [tiffMetadata allKeys];
    for (NSString *strKey in arr2) {
        NSLog(@"TIFF key: %@", strKey);
    }

    // 可以获取经纬度添加gps到元数据
    
    // 存入图片库
    UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 裁剪图片
    UIImage *smallImage = [MZGetPhotoViewController imageWithImage:originalImage scaledToSize:CGSizeMake(originalImage.size.width*0.25f, originalImage.size.height*0.25f)];
    
    NSURL *photoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"url %@", [photoUrl absoluteString]);
    
    // 将图片写入文件
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    NSString *photoName = [uuidStr stringByAppendingPathExtension:@"jpg"];
    CFRelease(uuid);
    
    NSString *photoPath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:photoName];
    NSData *imgData = UIImageJPEGRepresentation(smallImage, 1.0);
    if (imgData != nil && imgData.length >0) {
        [imgData writeToFile:photoPath atomically:YES]; 
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doAsynchronous:(id)sender {
    
    NSString *strURL = [self.myTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UIImageFromURL( [NSURL URLWithString:strURL],
                   ^( UIImage * image )
                   {
                       NSLog(@"%@",image);
                       self.imgView.image = image;
                   },
                   ^(void){
                       NSLog(@"%@",@"error!");
                   });
}

void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

	

- (void)viewDidUnload {
    [self setImgView:nil];
    [self setMyTextFiled:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}



@end
