//
//  MZGetPhotoViewController.h
//  MyTestAll
//
//  Created by uistrong on 12-11-6.
//
//

#import <UIKit/UIKit.h>

@interface MZGetPhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)doStartCamera:(id)sender;
- (IBAction)doEnumPhotos:(id)sender;
- (IBAction)doAsynchronous:(id)sender;
- (IBAction)doAssetURL:(id)sender;
- (IBAction)doAlertView:(id)sender;
@end
