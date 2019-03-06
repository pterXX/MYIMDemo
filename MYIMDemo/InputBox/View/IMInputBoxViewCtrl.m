//
//  IMInputBoxViewCtrl.m
//  KXiniuCloud
//
//  Created by eims on 2018/4/27.
//  Copyright © 2018年 EIMS. All rights reserved.
//

#import "IMInputBoxViewCtrl.h"

#import <SDWebImage/UIImage+GIF.h>
#import <AVFoundation/AVFoundation.h>

#import "IMTextView.h"
#import "IMEmojiModel.h"
#import "IMInputBoxView.h"
#import "NSDate+IMCategory.h"
#import "IMInputBoxMoreView.h"
#import "IMInputBoxEmojiView.h"
#import "NSTextAttachment+Emoji.h"


@interface IMInputBoxViewCtrl () <IMInputBoxViewDelegate>

// 文本消息
@property (nonatomic, strong) NSString *textMessage;

@property (nonatomic, assign) CGFloat  inputBoxHeight;

@property (nonatomic, assign) CGRect   keyboardFrame;

@end

@implementation IMInputBoxViewCtrl

#pragma mark 懒加载
- (IMInputBoxEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[IMInputBoxEmojiView alloc] initWithFrame:CGRectMake(0, self.inputBox.maxY, IMSCREEN_WIDTH, INPUT_BOX_EMOJI_VIEW_HEIGHT)];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (IMInputBoxMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[IMInputBoxMoreView alloc] initWithFrame:CGRectMake(0, self.inputBox.maxY, IMSCREEN_WIDTH, INPUT_BOX_MORE_VIEW_HEIGHT)];
    }
    return _moreView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = [IMColorTools colorWithHexString:@"0xeeeeee"];
    
    self.inputBox = [[IMInputBoxView alloc] initWithFrame:CGRectMake(0, 0, IMSCREEN_WIDTH, 50)];
    self.inputBox.delegate = self;
    [self addSubview:self.inputBox];
    [self moreView];
    
    [IMNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘的Frame值即将发生变化的时候创建的额监听
    [IMNotificationCenter addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [IMNotificationCenter addObserver:self selector:@selector(didSelectedMoreView:) name:@"IMInputBoxDidSelectedMoreView" object:nil];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.inputBox.mj_h = self.inputBox.curHeight;
    if (self.inputBox.inputBoxStatus == IMInputBoxStatusShowEmoji) {
        self.emojiView.mj_y = self.inputBox.curHeight;
    }
    else if (self.inputBox.inputBoxStatus == IMInputBoxStatusShowMore) {
        self.moreView.mj_y = self.inputBox.curHeight;
    }
}

- (BOOL)resignFirstResponder {

    if (self.inputBox.inputBoxStatus != IMInputBoxStatusShowVoice) {
        self.inputBox.inputBoxStatus = IMInputBoxStatusNone;
    }
    
    [self.inputBox resignFirstResponder];
    [self.emojiView removeFromSuperview];
    [self.moreView removeFromSuperview];
    
    return [super resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    if (self.inputBox.inputBoxStatus == IMInputBoxStatusShowEmoji || self.inputBox.inputBoxStatus == IMInputBoxStatusShowMore) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
        [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.inputBox.inputBoxStatus == IMInputBoxStatusShowKeyboard && self.keyboardFrame.size.height <= INPUT_BOX_MORE_VIEW_HEIGHT) {
        return;
    }
    else if ((self.inputBox.inputBoxStatus == IMInputBoxStatusShowEmoji || self.inputBox.inputBoxStatus == IMInputBoxStatusShowMore) && self.keyboardFrame.size.height <= INPUT_BOX_MORE_VIEW_HEIGHT) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
        // 改变控制器.View 的高度 键盘的高度 + 当前的 49
        [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.keyboardFrame.size.height + self.inputBox.curHeight];
    }
}

- (void)didSelectedMoreView:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    IMInputBoxMoreStatus inputBoxMoreStatus = [userInfo[@"status"] unsignedIntegerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxCtrl:didSelectedMoreView:)]) {
        [self.delegate inputBoxCtrl:self didSelectedMoreView:inputBoxMoreStatus];
    }
}

- (void)inputBox:(IMInputBoxView *)inputBox changeStatusForm:(IMInputBoxStatus)fromStatus to:(IMInputBoxStatus)toStatus {
    switch (toStatus) {
        case IMInputBoxStatusNone:
            
            break;
            case IMInputBoxStatusShowKeyboard:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.emojiView removeFromSuperview];
                [self.moreView removeFromSuperview];
                
            });
        }
            break;
        case IMInputBoxStatusShowVoice:
        {
            if (fromStatus == IMInputBoxStatusShowMore || fromStatus == IMInputBoxStatusShowEmoji) {
                [self.emojiView removeFromSuperview];
                [self.moreView removeFromSuperview];
                [UIView animateWithDuration:0.15 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                        [_delegate inputBoxCtrl:self didChangeInputBoxHeight:IMTABBAR_HEIGHT];
                    }
                }];
            }
            else {
                [UIView animateWithDuration:0.15 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                        [_delegate inputBoxCtrl:self didChangeInputBoxHeight:IMTABBAR_HEIGHT];
                    }
                }];
            }
        }
            break;
        case IMInputBoxStatusShowEmoji:
        {
            if (fromStatus == IMInputBoxStatusShowVoice || fromStatus == IMInputBoxStatusNone) {
                
                [self.emojiView setMj_y:self.inputBox.curHeight - IMSAFEAREA_INSETS_BOTTOM];
                // 添加表情View
                BOOL noEmpty = self.inputBox.inputView.text.length > 0;
                [self addSubview:self.emojiView];
                if (noEmpty) {
                    [self.emojiView.menuView.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.emojiView.menuView.sendButton setBackgroundColor:[IMColorTools colorWithHexString:@"0x0657b6"]];
                }
                
                if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                    [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight + INPUT_BOX_EMOJI_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM];
                }
            }
            else {
                // 表情高度变化
                self.emojiView.mj_h = self.inputBox.curHeight + INPUT_BOX_EMOJI_VIEW_HEIGHT;
                BOOL noEmpty = self.inputBox.inputView.text.length > 0;
                if (noEmpty) {
                    [self.emojiView.menuView.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.emojiView.menuView.sendButton setBackgroundColor:[IMColorTools colorWithHexString:@"0x0657b6"]];
                }
                [self addSubview:self.emojiView];
                
                [UIView animateWithDuration:0.15 animations:^{
                    
                    self.emojiView.mj_y = self.inputBox.curHeight;
                    
                } completion:^(BOOL finished) {
                    
                    [self.moreView removeFromSuperview];
                    
                }];
                
                // 整个界面高度变化
                if (fromStatus != IMInputBoxStatusShowMore) {
                    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                        [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight + INPUT_BOX_EMOJI_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM];
                    }
                }
            }
        }
            break;
        case IMInputBoxStatusShowMore:
        {
            if (fromStatus == IMInputBoxStatusShowVoice || fromStatus == IMInputBoxStatusNone) {
                [self.moreView setMj_y:self.inputBox.curHeight - IMSAFEAREA_INSETS_BOTTOM];
                
                [self addSubview:self.moreView];
                
                [UIView animateWithDuration:0.15 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                        [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight + INPUT_BOX_EMOJI_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM];
                    }
                }];
            }
            else {
                
                self.moreView.mj_y = self.inputBox.curHeight + INPUT_BOX_EMOJI_HEIGHT;
                [self.emojiView removeFromSuperview];
                
                [self addSubview:self.moreView];
                [UIView animateWithDuration:0.15 animations:^{
                    self.moreView.mj_y = self.inputBox.curHeight;
                } completion:nil];
                
                if (fromStatus != IMInputBoxStatusShowMore) {
                    
                    [UIView animateWithDuration:0.15 animations:^{
                        if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
                            [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight + INPUT_BOX_EMOJI_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM];
                        }
                    }];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)inputBox:(IMInputBoxView *)inputBox changeInputBoxHeight:(CGFloat)height {
    
    self.emojiView.mj_y = height;
    self.moreView.mj_y = height;
    if (_delegate && [_delegate respondsToSelector:@selector(inputBoxCtrl:didChangeInputBoxHeight:)]) {
        // 除了输入框之外的高度
        CGFloat extraHeight = 0;
        if (inputBox.inputBoxStatus == IMInputBoxStatusShowMore) {
            extraHeight = INPUT_BOX_MORE_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM;
        }
        else if (inputBox.inputBoxStatus == IMInputBoxStatusShowEmoji) {
            extraHeight = INPUT_BOX_EMOJI_VIEW_HEIGHT + IMSAFEAREA_INSETS_BOTTOM;
        }
        else if (inputBox.inputBoxStatus == IMInputBoxStatusShowKeyboard) {
            extraHeight = self.keyboardFrame.size.height;
        }
        else {
            extraHeight = 0;
        }
        [self.delegate inputBoxCtrl:self didChangeInputBoxHeight:self.inputBox.curHeight + extraHeight];
    }
}

- (void)inputBox:(IMInputBoxView *)inputBox sendTextMessage:(NSString *)textMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxCtrl:sendTextMessage:)]) {
        [self.delegate inputBoxCtrl:self sendTextMessage:textMessage];
    }
}

- (void)inputBox:(IMInputBoxView *)inputBox recordStatus:(IMInputBoxRecordStatus)recordState voicePath:(NSString *)voiceUrl recordTime:(CGFloat)recordTime {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxCtrl:recordStatus:voicePath:recordTime:)]) {
        [self.delegate inputBoxCtrl:self recordStatus:recordState voicePath:voiceUrl recordTime:recordTime];
    }
}


// 选择表情
- (void)emojiView:(IMInputBoxEmojiView *)emojiView didSelectEmoji:(IMEmojiModel *)emojiDic emojiType:(IMEmojiType)emojiType {

    NSRange range = self.inputBox.inputView.selectedRange;
    
    NSString *prefix = [self.inputBox.inputView.text substringToIndex:range.location];

    NSString *suffix = [self.inputBox.inputView.text substringFromIndex:range.length + range.location];
    self.inputBox.inputView.text = [NSString stringWithFormat:@"%@%@%@",prefix, emojiDic.emojiName, suffix];
    /********************需要在输入框直接显示表情***********************/
//    // 光标被多选
//    if (range.length > 0) {
//        [self.inputBox.inputView.textStorage deleteCharactersInRange:range];
//    }
//
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    //给附件添加图片
//    textAttachment.image = [UIImage sd_animatedGIFNamed:emojiDic[@"name"]];
//
//    textAttachment.emojiName = emojiDic[@"face_name"];
//    textAttachment.bounds = CGRectMake(0, -5, 20, 20);
//    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//
//    [self.inputBox.inputView.textStorage insertAttributedString:imageStr atIndex:self.inputBox.inputView.selectedRange.location];
//
//    [self.inputBox.inputView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:INPUT_BOX_TEXT_FONT] range:NSMakeRange(0, self.inputBox.inputView.textStorage.length)];
//    [self.inputBox.inputView.textStorage addAttribute:NSForegroundColorAttributeName value:INPUT_BOX_TEXTCOLOR range:NSMakeRange(0, self.inputBox.inputView.textStorage.length)];
//    self.inputBox.inputView.selectedRange = NSMakeRange(self.inputBox.inputView.selectedRange.location + 1, 0);
//    [self.inputBox textViewDidChange:self.inputBox.inputView];
//
    
}

- (void)emojiViewDeleteEmoji {
    [self.inputBox deleteEmoji];
}

// 点击添加表情
- (void)emojiMenuView:(IMInputBoxEmojiMenuView *)menuView clickAddAction:(UIButton *)addBut {
    
}

// 选择表情组
- (void)emojiMenuView:(IMInputBoxEmojiMenuView *)menuView didSelectEmojiGroup:(IMEmojiGroup *)emojiGroup {
    
}

- (void)emojiView:(IMInputBoxEmojiView *)emojiView sendEmoji:(NSString *)emojiStr {
    
    [self.inputBox sendCurrentMessage];
}

- (void)dealloc {
    [IMNotificationCenter removeObserver:self];
    [self.inputBox removeFromSuperview];
    self.inputBox = nil;
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
