//
//  IMChatGroupDetailViewController.m
//  IMChat
//
//  Created by 徐世杰 on 16/3/8.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatGroupDetailViewController.h"
#import "IMUserDetailViewController.h"
#import "IMGroupQRCodeViewController.h"
#import "IMChatFileViewController.h"

#import "IMMessageManager+MessageRecord.h"
#import "IMUserGroupCell.h"
#import "IMChatNotificationKey.h"
#import "IMSettingItem.h"

typedef NS_ENUM(NSInteger, IMChatGroupDetailVCSectionType) {
    IMChatGroupDetailVCSectionTypeUsers,
    IMChatGroupDetailVCSectionTypeGroupInfo,
    IMChatGroupDetailVCSectionTypeMiniApp,
    IMChatGroupDetailVCSectionTypeChatDetail,
    IMChatGroupDetailVCSectionTypeConversation,
    IMChatGroupDetailVCSectionTypeNickName,
    IMChatGroupDetailVCSectionTypeBG,
    IMChatGroupDetailVCSectionTypeRecord,
    IMChatGroupDetailVCSectionTypeReport,
    IMChatGroupDetailVCSectionTypeExit,
};

@implementation IMChatGroupDetailViewController

- (instancetype)initWithGroupModel:(id)groupModel
{
    if (self = [super init]) {
        _group = groupModel;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self resetTitle];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];

    [self loadChatGroupDetailUI:self.group];
}

#pragma mark - # UI
- (void)resetTitle
{
    [self setTitle:[NSString stringWithFormat:@"%@(%ld)", @"聊天详情", self.group.users.count]];
}

- (void)loadChatGroupDetailUI:(IMGroup *)group
{
    @weakify(self);
    self.clear();
    
    // 好友
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeUsers;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
        
        self.addCell(@"IMUserGroupCell").toSection(sectionTag).withDataModel(self.group.users).eventAction(^ id(IMUserGroupCellEventType eventType, id data) {
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
    
    // 基本信息
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeGroupInfo;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        // 名称
        IMSettingItem *nameItem = IMCreateSettingItem(@"群聊名称");
        nameItem.subtitle = group.groupName;
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(nameItem).selectedAction(^ (id data) {
            
        });
        
        // 二维码
        IMSettingItem *qrItem = IMCreateSettingItem(@"群二维码");
        qrItem.rightImagePath = @"mine_cell_myQR";
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(qrItem).selectedAction(^ (id data) {
            @strongify(self);
            IMGroupQRCodeViewController *gorupQRCodeVC = [[IMGroupQRCodeViewController alloc] initWithGroupModel:self.group];
            IMPushVC(gorupQRCodeVC);
        });
        
        // 群公告
        IMSettingItem *notiItem = IMCreateSettingItem(@"群公告");
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(notiItem).selectedAction(^ (id data) {
            
        });
    }
    
    // 小程序
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeMiniApp;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"聊天小程序")).selectedAction(^ (id data) {
            
        });
    }
    
    // 聊天记录
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeChatDetail;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"查找聊天记录")).selectedAction(^ (id data) {
            
        });
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"聊天文件")).selectedAction(^ (id data) {
            @strongify(self);
            IMChatFileViewController *chatFileVC = [[IMChatFileViewController alloc] init];
            [chatFileVC setPartnerID:self.group.groupID];
            IMPushVC(chatFileVC);
        });
    }
    
    
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeConversation;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        // 免打扰
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"消息免打扰")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
        
        // 置顶
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"置顶聊天")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
        
        // 保存
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"保存到通讯录")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
    }
    
    // 昵称
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeNickName;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        // 我的昵称
        IMSettingItem *nickNameItem = IMCreateSettingItem(@"我在本群的昵称");
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(nickNameItem).selectedAction(^ (id data) {
            @strongify(self);
//            IMChatBackgroundViewController *chatBGSettingVC = [[IMChatBackgroundViewController alloc] init];
//            [chatBGSettingVC setPartnerID:self.group.groupID];
//            IMPushVC(chatBGSettingVC);
        });
        
        // 成员昵称
        self.addCell(CELL_ST_ITEM_SWITCH).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"显示群成员昵称")).eventAction(^ id(NSInteger eventType, id data) {
            
            return nil;
        });
    }
    
    // 背景
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeBG;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"设置当前聊天背景")).selectedAction(^ (id data) {
            @strongify(self);
//            IMChatBackgroundViewController *chatBGSettingVC = [[IMChatBackgroundViewController alloc] init];
//            [chatBGSettingVC setPartnerID:self.group.groupID];
//            IMPushVC(chatBGSettingVC);
        });
    }
    
    // 清空聊天记录
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeRecord;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"清空聊天记录")).selectedAction(^ (id data) {
            IMActionSheet *actionSheet = [[IMActionSheet alloc] initWithTitle:nil clickAction:^(NSInteger buttonIndex) {
                @strongify(self);
                if (buttonIndex == 0) {
                    BOOL ok = [[IMMessageManager sharedInstance] deleteMessagesByPartnerID:self.group.groupID];
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
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeReport;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
        
        self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(IMCreateSettingItem(@"投诉")).selectedAction(^ (id data) {
            
        });
    }
    
    // 退出
    {
        NSInteger sectionTag = IMChatGroupDetailVCSectionTypeExit;
        self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 40, 0));
        
        self.addCell(@"IMSettingItemDeleteButtonCell").toSection(sectionTag).withDataModel(IMCreateSettingItem(@"删除并退出")).selectedAction(^ (id data) {
            
        });
    }
    
    [self reloadView];
}

@end
