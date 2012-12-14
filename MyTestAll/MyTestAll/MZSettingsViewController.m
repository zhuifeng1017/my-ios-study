//
//  MZSettingsViewController.m
//  MyTestAll
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZSettingsViewController.h"
#import "MZSettingCell.h"


#define kCellIdentifierStyleValue1 @"GOU.CellIdentifierStyleValue1"
#define kCellIdentifierStyleSwtich @"GOU.CellIdentifierStyleSwtich"
#define kCellIdentifierStyleSlider @"GOU.CellIdentifierStyleSlide"
#define kCellHeight 44
#define kSliderHeight 10

#define KSwitchInCellTag 1
#define kSlideInCellTag 2


@implementation SettingItem

@synthesize title;
@synthesize cellIdentifier;
@synthesize getValueSelector;


- (id) initWithProperty:(NSString*) strTitle cellIdentifier:(NSString*) strCellIdentifier getValueSelector:(NSString*)strSelector{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = strTitle;
        self.cellIdentifier = strCellIdentifier;
        self.getValueSelector = strSelector;
    }
    return self;
}

@end

////////////////////////////////////////////////////

@interface MZSettingsViewController ()
-(NSInteger)sectionCount;
-(NSInteger)sectionRowCount:(NSInteger)sectionIndex;
-(NSString*)sectionTitle:(NSInteger)sectionIndex;
-(SettingItem*)itemStringAtIndexPath:(NSIndexPath*)path;


// - switch control事件响应
- (void) doSwitchChanged:(id)sender;

// 系统设置
-(NSNumber*)getUnitValue;
-(NSNumber*) getDisplayWarningValue;

// 导航设置
//- (NSInteger)getRoadMode;


@end

@implementation MZSettingsViewController


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
    if(_sections == nil)
	{
        
        SettingItem *itemUnit = [[SettingItem alloc] initWithProperty:@"单位" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:@"getUnitValue"];
        SettingItem *itemWarning = [[SettingItem alloc] initWithProperty:@"显示警告画面" cellIdentifier:kCellIdentifierStyleSwtich getValueSelector:@"getDisplayWarningValue"];
        NSArray *systemItems = [[NSArray alloc] initWithObjects:itemUnit,itemWarning,nil];

        SettingItem *itemRouteMode = [[SettingItem alloc] initWithProperty:@"选路方式" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemAvoid = [[SettingItem alloc] initWithProperty:@"回避" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemsimuSpeed = [[SettingItem alloc] initWithProperty:@"模拟导航速度" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        NSArray *navigationItems = [[NSArray alloc] initWithObjects:itemRouteMode,itemAvoid,itemsimuSpeed, nil];
        
        SettingItem *itemMapParticular = [[SettingItem alloc] initWithProperty:@"地址详细程度" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemMapAngle = [[SettingItem alloc] initWithProperty:@"地图视角" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        NSArray *mapItems = [[NSArray alloc] initWithObjects:itemMapParticular,itemMapAngle, nil];
        
        
        SettingItem *itemVoiceSex = [[SettingItem alloc] initWithProperty:@"提示声音" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemMute = [[SettingItem alloc] initWithProperty:@"静音" cellIdentifier:kCellIdentifierStyleSwtich getValueSelector:nil];
        SettingItem *itemTelIncomming = [[SettingItem alloc] initWithProperty:@"来电时" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemVolume = [[SettingItem alloc] initWithProperty:@"" cellIdentifier:kCellIdentifierStyleSlider getValueSelector:nil];
        NSArray *voiceItems = [[NSArray alloc] initWithObjects:itemVoiceSex,itemMute,itemTelIncomming, itemVolume,nil];
        
        SettingItem *itemBackLight = [[SettingItem alloc] initWithProperty:@"背光" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemColorMode = [[SettingItem alloc] initWithProperty:@"颜色模式" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        NSArray *displayItems = [[NSArray alloc] initWithObjects:itemBackLight,itemColorMode, nil];
        
        
        // 航迹设置
        SettingItem *itemTrackOnOff = [[SettingItem alloc] initWithProperty:@"航迹记录" cellIdentifier:kCellIdentifierStyleSwtich getValueSelector:nil];
        SettingItem *itemTrackVisible = [[SettingItem alloc] initWithProperty:@"航迹显示" cellIdentifier:kCellIdentifierStyleSwtich getValueSelector:nil];
         SettingItem *itemTackMode= [[SettingItem alloc] initWithProperty:@"记录模式" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        NSArray *trackItems = [[NSArray alloc] initWithObjects:itemTrackOnOff,itemTrackVisible, itemTackMode, nil];
        
        // 报警点设置
        SettingItem *itemAlarm = [[SettingItem alloc] initWithProperty:@"报警" cellIdentifier:kCellIdentifierStyleSwtich getValueSelector:nil];
        SettingItem *itemAlarmType= [[SettingItem alloc] initWithProperty:@"报警点类型" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        NSArray *alarmItems = [[NSArray alloc] initWithObjects:itemAlarm, itemAlarmType, nil];
        
        //其他
        SettingItem *itemMapData = [[SettingItem alloc] initWithProperty:@"地图数据管理" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemAbout= [[SettingItem alloc] initWithProperty:@"关于" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemHelp= [[SettingItem alloc] initWithProperty:@"帮助" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];
        SettingItem *itemReset= [[SettingItem alloc] initWithProperty:@"恢复默认设置" cellIdentifier:kCellIdentifierStyleValue1 getValueSelector:nil];      
        NSArray *alarmOther = [[NSArray alloc] initWithObjects:itemMapData, itemAbout, itemHelp, itemReset,nil];
        
        
        _sectionNames = [[NSArray alloc] initWithObjects:@"系统设置",@"导航设置",@"地图设置",@"声音设置",@"显示设置",@"航迹设置", @"报警点设置", @"其他", nil];
        NSArray *allItems = [[NSArray alloc] initWithObjects:systemItems,navigationItems, mapItems,voiceItems,displayItems, trackItems, alarmItems, alarmOther, nil];
        
        _sections = [NSDictionary dictionaryWithObjects:allItems forKeys:_sectionNames];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) doBack{
    [self dismissModalViewControllerAnimated:YES];
}

-(NSInteger)sectionCount{
    return [_sections count];
}

-(NSInteger)sectionRowCount:(NSInteger)sectionIndex{
    return [[_sections objectForKey:[_sectionNames objectAtIndex:sectionIndex]] count];
}

-(NSString*)sectionTitle:(NSInteger)sectionIndex{
    return [_sectionNames objectAtIndex:sectionIndex];
}

- (void) doSwitchChanged:(id)sender{
    UISwitch *switchView = (UISwitch*)sender;
    NSInteger nTag = switchView.tag;
    NSLog(@"section:%d, row: %d", nTag&0xFFFF, (nTag>>16)&0xFFFF);
}

#pragma mark 系统设置

- (NSNumber*)getUnitValue{
    return [NSNumber numberWithInt:1];
}

- (NSNumber*) getDisplayWarningValue{
    return [NSNumber numberWithBool:YES];
}

#pragma mark UITableView data source methods

// tell our table how many sections or groups it will have (always 1(our case)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self sectionCount];
}

// tell our table how many rows it will have,(our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self sectionRowCount:section];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self sectionTitle:section];
}

-(SettingItem*)itemStringAtIndexPath:(NSIndexPath*)path{
    return [[_sections objectForKey:[_sectionNames objectAtIndex:path.section]] objectAtIndex:path.row];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingItem* item = [self itemStringAtIndexPath:indexPath];
    if (item.cellIdentifier == kCellIdentifierStyleValue1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierStyleValue1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifierStyleValue1];
        }
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = cell.textLabel.text;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.imageView.image = [UIImage imageNamed:@"my_work.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if(item.cellIdentifier == kCellIdentifierStyleSwtich){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierStyleSwtich];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifierStyleSwtich];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.tag = (indexPath.section | (indexPath.row<<16));
        if (item.getValueSelector!=nil) {
            NSNumber *val =  [self performSelector:NSSelectorFromString(item.getValueSelector) withObject:nil];
            [switchView setOn:[val boolValue] animated:NO];
        }
        [switchView addTarget:self action:@selector(doSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;

        cell.textLabel.text = item.title;
        cell.imageView.image = [UIImage imageNamed:@"my_work.png"];

        return cell;
    }
    else if (item.cellIdentifier == kCellIdentifierStyleSlider) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierStyleSlider];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifierStyleSlider];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            CGRect cellRect = cell.frame;
            UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(40, (cellRect.size.height-kSliderHeight)/2, cellRect.size.width-100, kSliderHeight)];
            [cell.contentView addSubview:sliderView];
            cell.imageView.image = [UIImage imageNamed:@"my_work.png"];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_work.png"]];
        }
        return cell;
    }
    
	return nil;
}


#pragma mark UITableView delegate methods

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView selectRowAtIndexPath:<#(NSIndexPath *)#> animated:<#(BOOL)#> scrollPosition:<#(UITableViewScrollPosition)#>
//	QuartzViewController *targetViewController = [self controllerAtIndexPath:indexPath];
//	[[self navigationController] pushViewController:targetViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

@end
