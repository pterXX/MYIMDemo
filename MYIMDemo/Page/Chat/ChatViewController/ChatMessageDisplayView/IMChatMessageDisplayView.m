//
//  IMChatMessageDisplayView.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/9.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatMessageDisplayView.h"
#import "IMChatMessageDisplayView+Delegate.h"
#import <MJRefresh/MJRefresh.h>
#import "IMMessageBaseCell.h"
#import "IMChatEventStatistics.h"

#define     PAGE_MESSAGE_COUNT      15

@interface IMChatMessageDisplayView ()

@property (nonatomic, strong) MJRefreshNormalHeader *refresHeader;

/// 用户决定新消息是否显示时间
@property (nonatomic, strong) NSDate *curDate;

@end

@implementation IMChatMessageDisplayView
@synthesize tableView = _tableView;
@synthesize data = _data;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        [self setDisablePullToRefresh:NO];
        [self registerCellClassForTableView:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView)];
        [self.tableView addGestureRecognizer:tap];
        
        [self.tableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.menuView dismiss];
    [self.tableView removeObserver:self forKeyPath:@"bounds"];
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc MessageDisplayView");
#endif
}

#pragma mark - # Public Methods
- (void)resetMessageView
{
    [self.data removeAllObjects];
    [self.tableView reloadData];
    self.curDate = [NSDate date];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refresHeader];
    }
    kWeakSelf(self);
    [self p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
        if (!hasMore) {
            weakSelf.tableView.mj_header = nil;
        }
        if (count > 0) {
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView scrollToBottomWithAnimation:NO];
            });
        }
    }];
}

- (void)addMessage:(IMMessage *)message
{
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void)setData:(NSMutableArray *)data
{
    _data = data;
    [self.tableView reloadData];
}

- (void)deleteMessage:(IMMessage *)message
{
    [self deleteMessage:message withAnimation:YES];
}

- (void)deleteMessage:(IMMessage *)message withAnimation:(BOOL)animation
{
    if (message == nil) {
        return;
    }
    NSInteger index = [self.data indexOfObject:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:deleteMessage:)]) {
        BOOL ok = [self.delegate chatMessageDisplayView:self deleteMessage:message];
        if (ok) {
            [self.data removeObject:message];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:animation ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
        }
        else {
            [IMUIUtility showAlertWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}

- (void)updateMessage:(IMMessage *)message
{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (id cell in visibleCells) {
        if ([cell isKindOfClass:[IMMessageBaseCell class]]) {
            if ([[(IMMessageBaseCell *)cell message].messageID isEqualToString:message.messageID]) {
                [cell updateMessage:message];
                return;
            }
        }
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)scrollToBottomWithAnimation:(BOOL)animation
{
    [self.tableView scrollToBottomWithAnimation:animation];
}

- (void)setDisablePullToRefresh:(BOOL)disablePullToRefresh
{
    if (disablePullToRefresh) {
        [self.tableView setMj_header:nil];
    }
    else {
        [self.tableView setMj_header:self.refresHeader];
    }
}

#pragma mark - # Event Response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.tableView && [keyPath isEqualToString:@"bounds"]) {  // tableView变小时，消息贴底
        CGRect oldBounds, newBounds;
        [change[@"old"] getValue:&oldBounds];
        [change[@"new"] getValue:&newBounds];
        CGFloat t = oldBounds.size.height - newBounds.size.height;
        if (t > 0 && fabs(self.tableView.contentOffset.y + t + newBounds.size.height - self.tableView.contentSize.height) < 1.0) {
            [self scrollToBottomWithAnimation:NO];
        }
    }
}

- (void)didTouchTableView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayViewDidTouched:)]) {
        [self.delegate chatMessageDisplayViewDidTouched:self];
    }
}

#pragma mark - # Private Methods
/**
 *  获取聊天历史记录
 */
- (void)p_tryToRefreshMoreRecord:(void (^)(NSInteger count, BOOL hasMore))complete
{
    kWeakSelf(self);
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessageDisplayView:getRecordsFromDate:count:completed:)]) {
        [self.delegate chatMessageDisplayView:self
                           getRecordsFromDate:self.curDate
                                        count:PAGE_MESSAGE_COUNT
                                    completed:^(NSDate *date, NSArray *array, BOOL hasMore) {
                                        if (array.count > 0 && [date isEqualToDate:weakSelf.curDate]) {
                                            weakSelf.curDate = [array[0] date];
                                            [weakSelf.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                                            complete(array.count, hasMore);
                                        }
                                        else {
                                            complete(0, hasMore);
                                        }
                                 }];
    }
}

#pragma mark - # Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (IMChatCellMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[IMChatCellMenuView alloc] init];
    }
    return _menuView;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (MJRefreshNormalHeader *)refresHeader
{
    if (_refresHeader == nil) {
        kWeakSelf(self);
        _refresHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
                [weakSelf.tableView.mj_header endRefreshing];
                if (!hasMore) {
                    weakSelf.tableView.mj_header = nil;
                }
                if (count > 0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }];
        }];
        _refresHeader.lastUpdatedTimeLabel.hidden = YES;
        _refresHeader.stateLabel.hidden = YES;
    }
    return _refresHeader;
}

@end
