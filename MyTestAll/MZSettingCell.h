//
//  MZSettingCell.h
//  MyTestAll
//
//  Created by  on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *swtich;
- (IBAction)doChange:(id)sender;

@end
