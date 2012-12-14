//
//  GUMenuItemView.m
//  MyTestAll
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GUMenuItemView.h"

@implementation GUMenuItemView
@synthesize itemIcon;
@synthesize itemLable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) SetItemData:(NSString*) iconPath lableText:(NSString*) lableText tag:(NSInteger) tag{
    [self.itemIcon setBackgroundImage:[UIImage imageNamed:iconPath] forState:UIControlStateNormal];
    self.itemLable.text = lableText;
    self.tag = tag;
}

- (IBAction)doItem:(id)sender {
}
@end
