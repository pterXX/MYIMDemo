//
//  IMChatDetailViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

// Controller
#import "IMChatDetailViewController.h"
#import "IMChatFileViewController.h"
#import "IMUserDetailViewController.h"
// Cells
#import "IMUserGroupCell.h"
// Other
#import "IMChatNotificationKey.h"
#import "IMMessageManager+MessageRecord.h"
#import "IMSettingItem.h"

typedef NS_ENUM(NSInteger, IMChatDetailVCSectionType) {
    IMChatDetailVCSectionTypeUsers,
    IMChatDetailVCSectionTypeMiniApp,
    IMChatDetailVCSectionTypeChatDetail,
    IMChatDetailVCSectionTypeConversation,
    IMChatDetailVCSectionTypeBG,
    IMChatDetailVCSectionTypeRecord,
    IMChatDetailVCSectionTypeReport,
};

@implementation IMChatDetailViewController

- (instancetype)initWithUserModel:(IMUser *)user
{
    if (self = [super init]) {
        _user = user;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self setTitle:@"聊天详情"];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];
    
    [self loadChatDetailUI];
}

- (void)loadChatDetailUI
{
    @weakify(self);
    self.clear();
    
    // 好友
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeUsers;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
        
        self.addCell(@"IMUserGroupCell").toSection(sectionTag).withDataModel(@[self.user]).eventAction(^ id(IMUserGroupCellEventType eventType, id data) {
            @strongify(self);
            if (eventType == IMUserGroupCellEventTypeClickUser) {
                IMUserDetailViewController *userDetailVC = [[IMUserDetailViewController alloc] initWithUserModel:data];
                IMPushVC(userDetailVC);
            }
            else if (eventType == IMUserGroupCellEventTypeAdd) {
                [IMUIUtility showAlertWithTitle:@"提示" message:@"添加讨论组成员"];
            }
            return nil;
        });;
    }
    
    // 小程序
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeMiniApp;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"聊天小程序")).selectedAction(^ (id data) {
            
        });
    }
    
    // 聊天记录
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeChatDetail;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"查找聊天记录")).selectedAction(^ (id data) {
            
        });
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"聊天文件")).selectedAction(^ (id data) {
            @strongify(self);
            IMChatFileViewController *chatFileVC = [[IMChatFileViewController alloc] init];
            [chatFileVC setPartnerID:self.user.userID];
            IMPushVC(chatFileVC);
        });
    }
    
    
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeConversation;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        // 置顶
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"置顶聊天")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
        
        // 免打扰
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"消息免打扰")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
    }
    
    // 背景
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeBG;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"设置当前聊天背景")).selectedAction(^ (id data) {
            @strongify(self);
//            IMChatBackgroundViewController *chatBGSettingVC = [[IMChatBackgroundViewController alloc] init];
//            [chatBGSettingVC setPartnerID:self.user.userID];
//            IMPushVC(chatBGSettingVC);
        });
    }
    
    // 清空聊天记录
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeRecord;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"清空聊天记录")).selectedAction(^ (id data) {
            IMActionSheet *actionSheet = [[IMActionSheet alloc] initWithTitle:nil clickAction:^(NSInteger buttonIndex) {
                @strongify(self);
                if (buttonIndex == 0) {
                    BOOL ok = [[IMMessageManager sharedInstance] deleteMessagesByPartnerID:self.user.userID];
                    if (!ok) {
                        [IMUIUtility showAlertWithTitle:@"错误" message:@"清空聊天记录失败"];
                    }
                    else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHAT_VIEW_RESET object:nil];
                    }
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空聊天记录" otherButtonTitles: nil];
            [actionSheet show];
        });
    }
    
    // 投诉
    {
        NSInteger sectionTag = IMChatDetailVCSectionTypeReport;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"投诉")).selectedAction(^ (id data) {
            
        });
    }
    
    [self reloadView];
}

@end
