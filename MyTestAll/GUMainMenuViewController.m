//
//  GUMainMenuViewController.m
//  MyTestAll
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GUMainMenuViewController.h"
#import "GUMenuItemView.h"

#define kMenuItemViewWidth 60
#define kMenuItemViewHeigth 80
#define kMenuColumn 4
#define KMenuItemViewSpaceX ((320-(kMenuItemViewWidth*kMenuColumn))/(kMenuColumn+1))
#define KMenuItemViewSpaceY 20


@interface GUMainMenuViewController ()
- (void) doBack;
@end

@implementation GUMainMenuViewController
@synthesize scrollView;

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

    float spaceX = KMenuItemViewSpaceX;
    float spaceY = KMenuItemViewSpaceY;
    float firstX = spaceX;
    float firstY = 44 + spaceY;
    
    CGRect lastRect = CGRectZero;
    for (int i=0; i < 30; i++) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GUMenuItemView" owner:self options:nil];
        GUMenuItemView *itemView = (GUMenuItemView *)[nib objectAtIndex:0];
        lastRect = CGRectMake(
                                      firstX + (i%kMenuColumn)*spaceX + (i%kMenuColumn)*kMenuItemViewWidth, 
                                      firstY + (i/kMenuColumn)*spaceY + (i/kMenuColumn)*kMenuItemViewHeigth,
                                      kMenuItemViewWidth,
                                      kMenuItemViewHeigth);
        itemView.frame = lastRect;
        [itemView SetItemData:i%2==0?@"My_blog2.png":@"my_work2.png" lableText:[NSString stringWithFormat:@"我的数据%d", i] tag:i];
        [self.scrollView addSubview:itemView];
    }
    [self.scrollView setContentSize:CGSizeMake(320, lastRect.origin.y + kMenuItemViewHeigth)];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) doBack{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
@end
