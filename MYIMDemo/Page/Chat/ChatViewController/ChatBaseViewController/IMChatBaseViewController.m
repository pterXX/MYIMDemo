//
//  IMChatBaseViewController.m
//  IMChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatBaseViewController.h"
#import "IMChatBaseViewController+Proxy.h"
#import "IMChatBaseViewController+ChatBar.h"
#import "IMChatBaseViewController+MessageDisplayView.h"
#import "NSFileManager+IMChat.h"

@implementation IMChatBaseViewController

- (void)loadView
{
    [super loadView];
    
    [[IMMessageManager sharedInstance] setMessageDelegate:self];
    
    [self.view addSubview:self.messageDisplayView];
    [self.view addSubview:self.chatBar];
    
    [self p_addMasonry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IMAudioPlayer sharedAudioPlayer] stopPlayingAudio];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[IMMoreKeyboard keyboard] dismissWithAnimation:NO];
    [[IMEmojiKeyboard keyboard] dismissWithAnimation:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc ChatBaseVC");
#endif
}

#pragma mark - # Public Methods
- (void)setPartner:(id<IMChatUserProtocol>)partner
{
    if (_partner && [[_partner chat_userID] isEqualToString:[partner chat_userID]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisplayView scrollToBottomWithAnimation:NO];
        });
        return;
    }
    _partner = partner;
    [self.navigationItem setTitle:[_partner chat_username]];
    [self resetChatVC];
}

- (void)setChatMoreKeyboardData:(NSMutableArray *)moreKeyboardData
{
    [self.moreKeyboard setChatMoreKeyboardData:moreKeyboardData];
}

- (void)setChatEmojiKeyboardData:(NSMutableArray *)emojiKeyboardData
{
    [self.emojiKeyboard setEmojiGroupData:emojiKeyboardData];
}

- (void)resetChatVC
{
    NSString *chatViewBGImage;
    if (self.partner) {
        chatViewBGImage = [[NSUserDefaults standardUserDefaults] objectForKey:[@"CHAT_BG_" stringByAppendingString:[self.partner chat_userID]]];
    }
    if (chatViewBGImage == nil) {
        chatViewBGImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHAT_BG_ALL"];
        if (chatViewBGImage == nil) {
            [self.view setBackgroundColor:[UIColor colorGrayCharcoalBG]];
        }
        else {
            NSString *imagePath = [NSFileManager pathUserChatBackgroundImage:chatViewBGImage];
            UIImage *image = [UIImage imageNamed:imagePath];
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
    }
    else {
        NSString *imagePath = [NSFileManager pathUserChatBackgroundImage:chatViewBGImage];
        UIImage *image = [UIImage imageNamed:imagePath];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
    
    [self resetChatTVC];
}

/**
 *  发送图片消息
 */
- (void)sendImageMessage:(UIImage *)image
{
    NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 0.5));
    NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
    NSString *imagePath = [NSFileManager pathUserChatImage:imageName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    IMImageMessage *message = [[IMImageMessage alloc] init];
    message.fromUser = self.user;
    message.ownerTyper = IMMessageOwnerTypeSelf;
    message.imagePath = imageName;
    message.imageSize = image.size;
    [self sendMessage:message];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    [self.messageDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(IMTABBAR_HEIGHT);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - # Getter
- (IMChatMessageDisplayView *)messageDisplayView
{
    if (_messageDisplayView == nil) {
        _messageDisplayView = [[IMChatMessageDisplayView alloc] init];
        [_messageDisplayView setDelegate:self];
    }
    return _messageDisplayView;
}

- (IMChatBar *)chatBar
{
    if (_chatBar == nil) {
        _chatBar = [[IMChatBar alloc] init];
        [_chatBar setDelegate:self];
    }
    return _chatBar;
}

- (IMEmojiDisplayView *)emojiDisplayView
{
    if (_emojiDisplayView == nil) {
        _emojiDisplayView = [[IMEmojiDisplayView alloc] init];
    }
    return _emojiDisplayView;
}

- (IMImageExpressionDisplayView *)imageExpressionDisplayView
{
    if (_imageExpressionDisplayView == nil) {
        _imageExpressionDisplayView = [[IMImageExpressionDisplayView alloc] init];
    }
    return _imageExpressionDisplayView;
}

- (IMRecorderIndicatorView *)recorderIndicatorView
{
    if (_recorderIndicatorView == nil) {
        _recorderIndicatorView = [[IMRecorderIndicatorView alloc] init];
    }
    return _recorderIndicatorView;
}

@end
