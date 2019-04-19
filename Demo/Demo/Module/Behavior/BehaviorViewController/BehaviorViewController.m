//
//  BehaviorViewController.m
//  Demo
//
//  Created by admin on 2019/4/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "BehaviorViewController.h"

// Cells
#import "BehaviorItemCell.h"
// Other


@interface BehaviorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray<BehaviorItem *> *dataSource;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation BehaviorViewController

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
    self.tableView                              = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor              = UIColorFromRGB(0xf6f6f6);
    self.tableView.separatorInset               = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor               = UIColorFromRGB(0xe5e5e5);
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
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
    BehaviorItem *item1  = createBehaviorItemModel(@"view_site_icon_72", nil, @"查看工地", @"0",nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item2  = createBehaviorItemModel(@"view_case_icon_72", nil, @"查看案例", @"0",nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item3  = createBehaviorItemModel(@"view_soft_text_icon_72", nil, @"查看软文", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item4  = createBehaviorItemModel(@"view_offers_icon_72", nil, @"查看优惠活动", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item5  = createBehaviorItemModel(@"view_business_card_icon_72", nil, @"查看名片", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item6  = createBehaviorItemModel(@"authorize_icon_72", nil, @"授权手机号", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item7  = createBehaviorItemModel(@"consult_icon_72", nil, @"咨询", @"0",nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item8  = createBehaviorItemModel(@"order_icon_72", nil, @"预约", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item9  = createBehaviorItemModel(@"call_the-phone_icon_72", nil, @"拨打电话", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    BehaviorItem *item10 = createBehaviorItemModel(@"save_business_card_icon_72", nil, @"保存名片", @"0", nil, ^(BehaviorItem *item) {
        NSLog(@"点击了%@",item.title);
    });
    
    self.dataSource = [NSMutableArray arrayWithObjects:item1, item2,item3,item4,item5,item6,item7,item8,item9,item10,nil];
    [self.tableView reloadData];
}

#pragma mark ================= Public =================
//  回滚到页面顶部,在标题栏切换的时候使用
- (void)scrollTop{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark ================= UITableViewDelegate,UITableViewDataSource =================
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *Identifier = @"cellIdentifier";
    BehaviorItemCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[BehaviorItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    [cell setModel:self.dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  执行对应Item的动作
    self.dataSource[indexPath.row].actionBlock(self.dataSource[indexPath.row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  返回cell的高度
    return [BehaviorItemCell viewHeightByDataModel:self.dataSource[indexPath.row]];
}
@end
