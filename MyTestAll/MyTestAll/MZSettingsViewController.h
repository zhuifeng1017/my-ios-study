//
//  MZSettingsViewController.h
//  MyTestAll
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* cellIdentifier;  //cell样式
@property (strong, nonatomic) NSString* getValueSelector;



- (id) initWithProperty:(NSString*) strTitle cellIdentifier:(NSString*) strCellIdentifier getValueSelector:(NSString*)strSelector;
@end

@interface MZSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
	NSDictionary *_sections;
	NSArray *_sectionNames;
   
}

@end




