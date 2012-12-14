//
//  GUMenuItemView.h
//  MyTestAll
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GUMenuItemView : UIView

@property (weak, nonatomic) IBOutlet UIButton *itemIcon;
@property (weak, nonatomic) IBOutlet UILabel *itemLable;
- (IBAction)doItem:(id)sender;


- (void) SetItemData:(NSString*) iconPath lableText:(NSString*) lableText tag:(NSInteger) tag;
@end
