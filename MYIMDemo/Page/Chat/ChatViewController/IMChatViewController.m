//
//  IMChatViewController.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatViewController.h"
#import "IMChatViewController+Delegate.h"
#import "IMChatDetailViewController.h"
#import "IMChatGroupDetailViewController.h"
#import "IMMoreKBHelper.h"
#import "IMEmojiKBHelper.h"
#import "IMUserHelper.h"
#import "IMChatNotificationKey.h"
#import "IMFriendHelper.h"

static IMChatViewController *chatVC;

@interface IMChatViewController()

@property (nonatomic, strong) IMMoreKBHelper *moreKBhelper;

@property (nonatomic, strong) IMEmojiKBHelper *emojiKBHelper;

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@end

@implementation IMChatViewController

- (instancetype)initWithUserId:(NSString *)userId
{
    if (self = [super init]) {
        IMUser *user = [[IMFriendHelper sharedFriendHelper] getFriendInfoByUserID:userId];
        self.partner = user;
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)groupId
{
    if (self = [super init]) {
        IMGroup *group = [[IMFriendHelper sharedFriendHelper] getGroupInfoByGroupID:groupId];
        self.partner = group;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    
    self.user = (id<IMChatUserProtocol>)[IMUserHelper sharedHelper].user;
    self.moreKBhelper = [[IMMoreKBHelper alloc] init];
    [self setChatMoreKeyboardData:self.moreKBhelper.chatMoreKeyboardData];
    self.emojiKBHelper = [IMEmojiKBHelper sharedKBHelper];
    kWeakSelf(self);
    [self.emojiKBHelper emojiGroupDataByUserID:[IMUserHelper sharedHelper].userID complete:^(NSMutableArray *emojiGroups) {
        [weakSelf setChatEmojiKeyboardData:emojiGroups];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetChatVC) name:NOTI_CHAT_VIEW_RESET object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc ChatVC");
#endif
}

#pragma mark - # Public Methods
- (void)setPartner:(id<IMChatUserProtocol>)partner
{
    [super setPartner:partner];
    if ([partner chat_userType] == IMChatUserTypeUser) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_single"]];
    }
    else if ([partner chat_userType] == IMChatUserTypeGroup) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_multi"]];
    }
}

#pragma mark - # Event Response
- (void)rightBarButtonDown:(UINavigationBar *)sender
{
    if ([self.partner chat_userType] == IMChatUserTypeUser) {
        IMChatDetailViewController *chatDetailVC = [[IMChatDetailViewController alloc] initWithUserModel:(IMUser *)self.partner];
        IMPushVC(chatDetailVC);
    }
    else if ([self.partner chat_userType] == IMChatUserTypeGroup) {
        IMChatGroupDetailViewController *chatGroupDetailVC = [[IMChatGroupDetailViewController alloc] initWithGroupModel:(IMGroup *)self.partner];
        IMPushVC(chatGroupDetailVC);
    }
}

#pragma mark - # Getter
- (UIBarButtonItem *)rightBarButton
{
    if (_rightBarButton == nil) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    }
    return _rightBarButton;
}
@end
