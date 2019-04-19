//
//  BehaviorTimeViewController.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

// Controller
#import "BehaviorDetailViewController.h"
#import "ViewController.h"
// Cells
#import "BehaviorTimeCell.h"
// Manager
#import "LTSCalendarManager.h"
// Other

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerPreviewingDelegate,
LTSCalendarEventSource
>
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic,strong)LTSCalendarManager *manager;
@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    [self p_loadUI];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self p_initData];
}

#pragma mark ================= private =================
//  加载UI
- (void)p_loadUI{
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 30)];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame)-64)];
    [self.manager.calenderScrollView setBgColor:UIColorFromRGB(0xf6f6f6)];
    
    [LTSCalendarAppearance share].weekDayTextFont = [UIFont systemFontOfSize:12];
    [LTSCalendarAppearance share].weekDayTextColor = UIColorFromRGB(0x999999);
    [LTSCalendarAppearance share].dayTextFont = [UIFont boldSystemFontOfSize:16];
    [LTSCalendarAppearance share].dayTextColor = UIColorFromRGB(0x333333);
    [LTSCalendarAppearance share].dayCircleColorSelected = UIColorFromRGB(0x15d1a5);
    [LTSCalendarAppearance share].dayCircleColorToday = UIColorFromRGB(0x15d1a5);
    //[LTSCalendarAppearance share].dayBorderColorToday = [UIColor clearColor];
    [LTSCalendarAppearance share].isShowLunarCalender = YES;
    //[LTSCalendarAppearance share].weekDayFormat = LTSCalendarWeekDayFormatSingle;
    [self.manager reloadAppearanceAndData];
    [self.manager showSingleWeek];
    
    [self.view addSubview:self.manager.weekDayView];
    [self.view addSubview:self.manager.calenderScrollView];
    //    [self.manager.weekDayView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //    }];
    //
    //    [self.manager.calenderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //    }];
    
    self.tableView                              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor              = UIColorFromRGB(0xf6f6f6);
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone; //  取消分割线
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 7.5)]; //  默认7.5 的高度
    self.tableView.tableFooterView              = [UIView new];
    self.tableView.delegate                     = self;
    self.tableView.dataSource                   = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

//  初始化数据
- (void)p_initData{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@(1)];
    [self.dataSource addObject:@(2)];
    [self.dataSource addObject:@(3)];
    [self.dataSource addObject:@(4)];
    [self.dataSource addObject:@(5)];
    [self.dataSource addObject:@(6)];
    [self.dataSource addObject:@(7)];
    [self.dataSource addObject:@(8)];
    [self.dataSource addObject:@(9)];
    [self.dataSource addObject:@(10)];
    [self.dataSource addObject:@(11)];
    [self.dataSource addObject:@(12)];
    [self.dataSource addObject:@(13)];
    [self.dataSource addObject:@(14)];
}

#pragma mark ================= Public =================
- (void)scrollTop{
    //  回滚到最顶不在顶部标题栏切换的时候使用
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark ================= UITableViewDelegate,UITableViewDataSource =================
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *Identifier = @"cellIdentifier";
    //  BehaviorTimeCell
    BehaviorTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[BehaviorTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        //  注册3D Touch
        if ([self respondsToSelector:@selector(traitCollection)]) {
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]
                && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
            }
        }
        
        //  聊天按钮点击回调的Block
        [cell setChatBtnPressBlock:^(id  _Nonnull model) {
            NSLog(@"model %@",model);
        }];
    }
    //  赋值显示数据
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  获取高度
    return [BehaviorTimeCell viewHeightByDataModel:self.dataSource[indexPath.row]];
}

#pragma mark ================= UIViewControllerPreviewingDelegate  =================
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    //  3D touch
    BehaviorTimeCell *cell = (BehaviorTimeCell *)[previewingContext sourceView];
    previewingContext.sourceRect = cell.bgView.frame;
    // 创建要预览的控制器
    BehaviorDetailViewController *presentationVC = [[BehaviorDetailViewController alloc] init];
    return presentationVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    //  进行跳转
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark ================= LTSCalendarEventSource =================
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)curdate selDate:(NSDate*)date {
    //  转换成当前时区
}

/**
 根据当前时区转换时间
 
 @param date 需要转换的时间
 @return 返回当前失去的时间
 */
- (NSDate *)dateTimeZone:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];
    date = [date dateByAddingTimeInterval:[zone secondsFromGMT]];
    return date;
}

@end
