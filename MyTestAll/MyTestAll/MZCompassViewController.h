//
//  MZCompassViewController.h
//  MyTestAll
//
//  Created by  on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MZLocation.h"

@interface MZCompassViewController : UIViewController <MZLocationModelDelegate>
{
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIImageView *compassView;
@end
