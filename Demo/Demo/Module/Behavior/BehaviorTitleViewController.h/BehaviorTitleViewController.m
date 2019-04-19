//
//  BehaviorTitleViewController.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

// Controller
#import "BehaviorTimeViewController.h"
#import "BehaviorTitleViewController.h"
#import "BehaviorViewController.h"
// Views
#import "BAPageTabView.h"
// Other

@interface BehaviorTitleViewController ()<BAPageTabViewDelegate>
{
    BAPageTabView *_pageTabView; //  标题栏
}
@property (nonatomic, strong)  BehaviorTimeViewController *title_0VC; //   时间
@property (nonatomic, strong)  BehaviorViewController *title_1VC;   //  行为
@end

@implementation BehaviorTitleViewController

#pragma mark - life cycle
-(void)loadView{
    [super loadView];
    // 初始化segmentTypeView
    [self setupSegmentTypeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - 初始化segmentType_0View
- (void)setupSegmentTypeView {
    self.navigationItem.title = @"嗨装";
    // 1.时间
    _title_0VC = [[BehaviorTimeViewController alloc] init];
    // 2.行为
    _title_1VC = [[BehaviorViewController alloc] init];
    //  添加为子视图,添加顺序不能相反
    [self addChildViewController:_title_0VC];
    [self addChildViewController:_title_1VC];
    
    //  标题栏, 将本页面的 self.childViewControllers  赋值给标题栏，方便控制视图的切换
    _pageTabView = [[BAPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:@[@"时间", @"行为"]];
    _pageTabView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    _pageTabView.tabHeight = 44;
    _pageTabView.tabItemFont = [UIFont systemFontOfSize:15];
    _pageTabView.unSelectedColor = UIColorFromRGB(0x333333);
    _pageTabView.selectedColor = PROJECT_GREENCOLOR;
    _pageTabView.bodyBounces = NO;
    _pageTabView.titleStyle = BAPageTabTitleStyleDefault;
    _pageTabView.indicatorStyle = BAPageTabIndicatorStyleFollowText;
    _pageTabView.delegate = self;
    [self.view addSubview:_pageTabView];
    
    //  禁止 view渗透到导航栏
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [_pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - BAPageTabViewDelegate
//  标题栏切换
- (void)pageTabViewDidEndChange {
    NSInteger selectedTabIndex = _pageTabView.selectedTabIndex;
    NSLog(@"点击了index：%zd", selectedTabIndex);
    // 页面全部中的数据全部回滚到顶部
    [_title_0VC scrollTop];
    [_title_1VC scrollTop];
    
    switch (selectedTabIndex) {
        case 0:
        {
           //  时间
        }
            break;
        case 1:
        {
            // 行为
        }
            break;
    }
}

@end

