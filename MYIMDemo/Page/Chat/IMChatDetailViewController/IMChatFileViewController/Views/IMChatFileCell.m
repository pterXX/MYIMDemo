//
//  IMChatFileCell.m
//  IMChat
//
//  Created by 李伯坤 on 16/3/18.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatFileCell.h"
#import "NSFileManager+IMChat.h"

@interface IMChatFileCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMChatFileCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}

- (void)setMessage:(IMMessage *)message
{
    _message = message;
    if (message.messageType == IMMessageTypeImage) {
        if ([(IMImageMessage *)message imagePath].length > 0) {
            NSString *imagePath = [NSFileManager pathUserChatImage:[(IMImageMessage *)message imagePath]];
            [self.imageView setImage:[UIImage imageNamed:imagePath]];
        }
        else if ([(IMImageMessage *)message imageURL].length > 0) {
            [self.imageView tt_setImageWithURL:IMURL([(IMImageMessage *)message imageURL]) placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR_PATH]];
        }
        else {
            [self.imageView setImage:nil];
        }
    }
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter -
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
