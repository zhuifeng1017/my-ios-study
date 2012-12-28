//
//  MZAlertView.m
//  MyTestAll
//
//  Created by uistrong on 12-12-28.
//
//

#import "MZAlertView.h"

@implementation MZAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    NSLog(@"dismissWithClickedButtonIndex");
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

//- (void) layoutSubviews{
//    NSLog(@" AlertView layoutSubviews");
//    for (UIView *v in self.subviews) {
//        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
//            UIButton *button = (UIButton *)v;
//            NSLog(@"btn tag : %d", button.tag);
//            if (button.tag != 1) {
//                button.enabled = NO;
//            }else{
//                
//            }
//        }
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
