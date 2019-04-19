//
//  BehaviorTimeViewController.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

// Controller
#import "BehaviorDetailViewController.h"
#import "BehaviorTimeViewController.h"
// Views
#import "BehaviorCalendarScrollView.h"
// Cells
#import "BehaviorTimeCell.h"
// Manager
#import "LTSCalendarManager.h"
// Other

@interface BehaviorTimeViewController ()
<
LTSCalendarEventSource
>
@property (nonatomic,strong)LTSCalendarManager *manager;
@end

@implementation BehaviorTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lts_InitUI];
    
}

- (void)lts_InitUI{
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [self.view addSubview:self.manager.weekDayView];
    
    CGFloat maxY = CGRectGetMaxY(self.manager.weekDayView.frame);
    CGFloat height = self.view.frame.size.height - 44 - maxY;
    height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (self.navigationController) {
         height -= self.navigationController.navigationBar.frame.size.height;
    }
    BehaviorCalendarScrollView *scrollView = [[BehaviorCalendarScrollView alloc] initWithFrame:CGRectMake(0, maxY, self.view.frame.size.width, height)];
    scrollView.viewController = self;
    self.manager.calenderScrollView = scrollView;
    [self.view addSubview:self.manager.calenderScrollView];
    
    [LTSCalendarAppearance share].weekDayTextFont = [UIFont systemFontOfSize:12];
    [LTSCalendarAppearance share].weekDayTextColor = UIColorFromRGB(0x999999);
    [LTSCalendarAppearance share].dayTextFont = [UIFont boldSystemFontOfSize:16];
    [LTSCalendarAppearance share].dayTextColor = UIColorFromRGB(0x333333);
    
    [LTSCalendarAppearance share].dayCircleColorSelected = UIColorFromRGB(0x15d1a5);
    [LTSCalendarAppearance share].dayCircleColorToday = UIColorFromRGB(0x15d1a5);
    //[LTSCalendarAppearance share].dayBorderColorToday = [UIColor clearColor];
    [LTSCalendarAppearance share].isShowLunarCalender = YES;
    
    /// 重新加载外观和数据
    [self.manager reloadAppearanceAndData];
    [self.manager showSingleWeek];
    
    //设置默认滑动选中
    //[LTSCalendarAppearance share].defaultSelected = false;
    //设置显示单周时滑动默认选中星期几
    //[LTSCalendarAppearance share].singWeekDefaultSelectedIndex = 2;
}

// 滚动到顶部
- (void)scrollTop{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

