//
//  MZTestMiniZipViewController.h
//  MyTestAll
//
//  Created by uistrong on 12-10-24.
//
//

#import <UIKit/UIKit.h>

@interface MZTestMiniZipViewController : UIViewController
{
    NSString *_str;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)doTestMinizip:(id)sender;

- (IBAction)doTest2:(id)sender;
@end
