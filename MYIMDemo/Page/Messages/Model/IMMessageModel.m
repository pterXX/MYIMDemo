//
//  IMMessageModel.m
//  MYIMDemo
//
//  Created by 徐世杰 on 2019/3/1.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMMessageModel.h"
#import "NSDictionary+Json.h"

@implementation IMMessageModel
- (instancetype)init {
    
    _cellHeight  = -1;
    _messageSize = CGSizeMake(-1, -1);
    
    return [super init];
    
}

- (void)setMessageAtt:(NSAttributedString *)messageAtt {
    _messageAtt = [IMChatMessageHelper formatMessageAtt:messageAtt];
}

- (void)setContent:(id)content {
    _content = content;
    if ([content isKindOfClass:[NSString class]]) {
        _messageAtt = [IMChatMessageHelper formatMessageString:content];
    }
}

- (void)setmsgType:(IMMessageType)msgType
{
    _msgType = msgType;
    if (msgType == IMMessageTypeVoice && self.recvTime == 0) {
        _cellHeight = 60;
    }
}

- (void)setSelfSenderMailShowReply:(BOOL)selfSenderMailShowReply
{
    _selfSenderMailShowReply = selfSenderMailShowReply;
    
    if (selfSenderMailShowReply) {
        _messageSize = CGSizeMake(_messageSize.width, _messageSize.height + 40);
        _cellHeight = _cellHeight + 40;
    }
}

- (NSData *)fileData{
    if (_fileData == nil && (self.msgType == IMMessageTypeImage || self.msgType == IMMessageTypeVideo)) {
        if ([_content isKindOfClass:[NSData class]]) {
            _fileData = _content;
        }else{
             _fileData = [[NSData alloc] initWithBase64EncodedString:self.content options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
    }
    return _fileData;
}

- (NSString *)contentSynopsis {
    if (!_contentSynopsis) {
        return @"";
    }
    return _contentSynopsis;
}

- (NSString *)cellIdendtifier
{
    switch (_msgType) {
        case IMMessageTypeNone:
            return @"";
            break;
        case IMMessageTypeText:
            return @"IMChatTextTableViewCell";
            break;
        case IMMessageTypeMail:
            return @"IMChatMailTableViewCell";
            break;
        case IMMessageTypeVoice:
            return @"IMChatVoiceTableViewCell";
            break;
        case IMMessageTypeImage:
            return @"IMChatImageTableViewCell";
            break;
        case IMMessageTypeVideo:
            return @"IMChatVideoTableViewCell";
            break;
        case IMMessageTypeFile:
            return @"";
            break;
        case IMMessageTypeLocation:
            return @"";
            break;
        case IMMessageTypeCard:
            return @"";
            break;
            
        default:
            break;
    }
}

- (NSString *)messageBody{
    switch (_msgType) {
        case IMMessageTypeNone:   // 头部 其他
            return @"[未知消息]";
            break;
        case IMMessageTypeText :    // 文字消息  包含表情
            return self.content;
            break;
        case IMMessageTypeVoice:       // 语音消息
            return @"[语音]";
            break;
        case IMMessageTypeImage:       // 图片消息
            return @"[图片]";
            break;
        case IMMessageTypeMail:        // 邮件消息
            return @"[邮件]";
            break;
        case IMMessageTypeVideo:       // 视频消息
            return @"[视频]";
            break;
        case IMMessageTypeFile:       // 文件消息
            return @"[文件]";
            break;
        case IMMessageTypeLocation:    // 位置消息
            return @"[位置]";
            break;
        case IMMessageTypeCard:         // 名片消息
            return @"[名片]";
            break;
        default:
            break;
    }
}


- (NSString *)modelConverJson{
    //  如果包含文件
    NSMutableDictionary *dict = @{
                       msg_id_key:IMNoNilString(self.messageId),
                       msg_type_key:IMStirngFormat(@"%ld",(long)self.msgType),
                       msg_content_key:self.content,
                       chat_type_key:IMStirngFormat(@"%ld",(long)self.messageChatType),
                       send_time_key:IMNoNilString(self.sendTime),
                       voice_time_key:IMNoNilString(self.voiceTime),
                       picture_type_key:IMStirngFormat(@"%ld",(long)self.pictureType),
                       }.mutableCopy;
    return [dict dictionaryTurnJson];
}

/**
 消息处理
 主要是计算视图高度，
 优化重复计算高度问题，
 把高度计算从加载时提前到赋值时
 */
- (void)messageProcessingWithFinishedCalculate:(FinishedRowHeightCalculate)finishedCalculate
{
    if (_cellHeight == -1 || _messageSize.width == -1 || _messageSize.height == -1)
    {
        _cellHeight = 0;
        if (_msgType != IMMessageTypeNone)
        {
            kWeakSelf;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                __block CGSize messageSize = CGSizeZero;
                
                switch (self.msgType)
                {
                    case IMMessageTypeText:
                    {
                        if ((!weakSelf.messageAtt || weakSelf.messageAtt.length == 0) && weakSelf.content) {
                            weakSelf.messageAtt = [IMChatMessageHelper formatMessageString:weakSelf.content];
                        }
                        
                        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin;
                        messageSize = [weakSelf.messageAtt boundingRectWithSize:CGSizeMake(ceil(MESSAGE_MAX_WIDTH)-10, MAXFLOAT) options:options context:nil].size;
                        weakSelf.messageSize = CGSizeMake(ceil(messageSize.width) + 10, ceil(messageSize.height) + 16);
                        
                        weakSelf.cellHeight = MAX(weakSelf.messageSize.height, 40) + weakSelf.cellHeight;
                        weakSelf.cellHeight = weakSelf.cellHeight + MESSAGE_BACKGROUND_SPACE * 2;
                        if (weakSelf.direction == IMMessageSenderTypeReceiver && weakSelf.showUsername) {
                            weakSelf.cellHeight = weakSelf.cellHeight + USERNAME_HEIGHT;
                        }
                        
                        [weakSelf updateDatabaseMessageHeightAndWidthWithRowHeight:weakSelf.cellHeight];
                    }
                        break;
                    case IMMessageTypeMail:
                    {
                        [weakSelf mailHeight];
                    }
                        break;
                    case IMMessageTypeVoice:
                    {
                        CGFloat rowHeight = AVATAR_WIDTH + 2 * AVATAR_SCREEN_SPACE;
                        if (weakSelf.direction == IMMessageSenderTypeReceiver && weakSelf.showUsername)
                        {
                            rowHeight = rowHeight + USERNAME_HEIGHT;
                        }
                        
                        weakSelf.cellHeight = rowHeight;
                        [weakSelf updateDatabaseMessageHeightAndWidthWithRowHeight:rowHeight];
                    }
                        break;
                        
                    case IMMessageTypeImage:
                    {
                        __block UIImage *image;
                        if (weakSelf.fileData) {
                            image = [UIImage imageWithData:weakSelf.fileData];
                            [weakSelf photoHeightWithImageWidth:image.size.width imageHeight:image.size.height complete:finishedCalculate];
                            return;
                        }
                        NSString *path = self->_content;
                        if ([path containsString:@"storage/msgs"]) {
                            NSString *imagePath = [kDocDir stringByAppendingPathComponent:path];
                            image               = [UIImage imageWithContentsOfFile:imagePath];
                            weakSelf.fileData   = UIImagePNGRepresentation(image);
                            [weakSelf photoHeightWithImageWidth:image.size.width imageHeight:image.size.height complete:finishedCalculate];
                            return;
                        }
                        else {
                            if ([path containsString:@"http://"] || [path containsString:@"https://"]) {
                                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_content] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                    if (!error) {
                                        [weakSelf photoHeightWithImageWidth:image.size.width imageHeight:image.size.height complete:finishedCalculate];
                                    }
                                }];
                                return;
                            }
                        }
                    }
                        break;
                    case IMMessageTypeVideo:
                    {
                        NSURL *url = [NSURL URLWithString:weakSelf.content];
                        weakSelf.fileData = UIImagePNGRepresentation([UIImage imageWithVideo:url]);
                        
                        UIImage *image = [UIImage imageWithData:weakSelf.fileData];
                        CGFloat imageWidth  = image.size.width;
                        CGFloat imageHeight = image.size.height;
                        if (imageWidth > imageHeight) {
                            // H : W = 16 : 9;
                            CGFloat width  = 180;
                            CGFloat height = width * 9 / 16.f;
                            messageSize = CGSizeMake(width, height);
                        }
                        else {
                            // H : W = 16 : 9
                            CGFloat height = 180;
                            CGFloat width  = height * 9 / 16.f;
                            messageSize = CGSizeMake(width, height);
                        }
                        weakSelf.messageSize = messageSize;
                        CGFloat rowHeight = messageSize.height + MESSAGE_BACKGROUND_SPACE * 2;
                        if (weakSelf.direction == IMMessageSenderTypeReceiver && weakSelf.showUsername) {
                            rowHeight = rowHeight + USERNAME_HEIGHT;
                        }
                        weakSelf.cellHeight = rowHeight;
                        
                        [weakSelf updateDatabaseMessageHeightAndWidthWithRowHeight:rowHeight];
                    }
                        break;
                        
                    default:
                    {
                        weakSelf.messageSize = CGSizeZero;
                        weakSelf.cellHeight  = 0;
                    }
                        break;
                }
                
                CGFloat height = weakSelf.cellHeight;
                if (finishedCalculate) {
                    if (weakSelf.showMessageTime) {
                        weakSelf.cellHeight += SHOW_MESSAGE_TIME_HEIGHT;
                    }
                    finishedCalculate(weakSelf.cellHeight, weakSelf.messageSize, YES);
                }
                
                if (weakSelf.messageId) {
                    // 通知聊天界面刷新这个消息
                    if (weakSelf.showMessageTime) {
                        height += SHOW_MESSAGE_TIME_HEIGHT;
                    }
                    [IMNotificationCenter postNotificationName:@"updateRowHeight" object:nil userInfo:@{@"messageId":weakSelf.messageId, @"cellHeight":@(height), @"messageSize":@(_messageSize)}];
                }
                
            });
        }
    }
    else {
        if (finishedCalculate) {
            if (_showMessageTime && !_updatedRowHeight) {
                _cellHeight += SHOW_MESSAGE_TIME_HEIGHT;
            }
            finishedCalculate(_cellHeight, _messageSize, YES);
        }
    }
}

- (void)updateDatabaseMessageHeightAndWidthWithRowHeight:(CGFloat)rowHeight
{
    if (_messageId)
    {
        //        NSLog(@"content:%@   rowHeight:%@", _content,rowHeight);
        //        [KInteractionWrapper updateMessageWithMessageId:_messageId cellHeight:rowHeight messageWidth:_messageSize.width messageHeight:_messageSize.height block:^(id obj, int errorCode, NSString *errorMsg) {
        //            if (errorCode) {
        //                NSLog(@"更新行高失败");
        //            }
        //        }];
    }
}

- (void)mailHeight
{
    CGSize messageSize;
    
    if (_subject || _contentSynopsis.length > 0) {
        // 最顶部的16 + 4 + mailTitle高度 + 4 + mailDetail高度 + 5 + 附件高度(MAIL_ATTACHMENT_HEIGHT) + 5 +底部高度（40）
        CGFloat mailHeight    = 16 + 4 + 0 + 4 + 0 + 5 + MAIL_ATTACHMENT_HEIGHT + 5 + 40;
        CGFloat mailWidth     = MESSAGE_MAX_WIDTH - 2*MESSAGE_BACKGROUND_SPACE;
        CGSize mailTitleSize  = [self.subject kSizeWithFont:[UIFont systemFontOfSize:CHAT_MESSAGE_FONT] constrainedToSize:CGSizeMake(mailWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        // + 内容和标题之间的间隙
        mailHeight            = mailHeight + ceil(mailTitleSize.height) + 10;
        
        CGSize mailDetailSize = [self.contentSynopsis kSizeWithFont:[UIFont systemFontOfSize:MAIL_DETAIL_FONT] constrainedToSize:CGSizeMake(MESSAGE_MAX_WIDTH - 2*MESSAGE_BACKGROUND_SPACE, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        mailHeight = mailHeight + mailDetailSize.height;
        // 加上顶部间隔（10）+ 顶部消息与消息背景的间隔（10）+ 加上底部间隔（10）+ 底部消息与消息背景的间隔（10）
        mailHeight = mailHeight + MESSAGE_BACKGROUND_SPACE * 4;
        if (self.attach == 0) {
            // 没有附件 则mailHeight = mailHeight - 附件高度（MAIL_ATTACHMENT_HEIGHT）- 附件与邮件详情简介的间隔（10）
            mailHeight = mailHeight - MAIL_ATTACHMENT_HEIGHT - 8;
        }
        
        if (self.direction == IMMessageSenderTypeReceiver) {
            mailHeight -= 10;
            mailHeight = mailHeight > RECEIVE_MAIL_MAX_ROW_HEIGHT ? RECEIVE_MAIL_MAX_ROW_HEIGHT : mailHeight;
        }
        else
        {
            // 去掉底部“回复”、“回复全部”和“转发”试图的高度
            mailHeight = self.selfSenderMailShowReply ? mailHeight : mailHeight - 40;
            CGFloat thresholdValue = self.selfSenderMailShowReply ? RECEIVE_MAIL_MAX_ROW_HEIGHT : SENDER_MAIL_MAX_ROW_HEIGHT;
            mailHeight = mailHeight > thresholdValue ? thresholdValue : mailHeight;
        }
        
        if (self.showUsername && self.direction == IMMessageSenderTypeReceiver) {
            mailHeight = mailHeight + USERNAME_HEIGHT;
        }
        messageSize  = CGSizeMake(mailWidth, mailHeight);
        _messageSize = messageSize;
        _cellHeight  = messageSize.height;
        
        [self updateDatabaseMessageHeightAndWidthWithRowHeight:messageSize.height];
    }
    
}

/**
 辅助计算网络图片消息行高
 
 @param imageWidth 图片宽
 @param imageHeight 图片高
 @param complete 高度计算完成回调
 */
- (void)photoHeightWithImageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight complete:(FinishedRowHeightCalculate)complete {
    
    CGSize messageSize;
    if (imageWidth > imageHeight)
    {
        if (imageWidth/2. > 180) {
            CGFloat width  = 180;
            CGFloat height = width * 9 / 16.f;
            messageSize    = CGSizeMake(width, height);
        }
        else {
            messageSize = CGSizeMake(imageWidth/2., imageHeight/2.);
        }
    }
    else
    {
        if (imageHeight/2. > 180) {
            CGFloat height = 180;
            CGFloat width  = height * 9 / 16.f;
            messageSize    = CGSizeMake(width, height);
        }
        else {
            messageSize = CGSizeMake(imageWidth/2., imageHeight/2.);
        }
    }
    
    _messageSize = messageSize;
    CGFloat rowHeight = messageSize.height + MESSAGE_BACKGROUND_SPACE * 2;
    if (self.direction == IMMessageSenderTypeReceiver && self.showUsername) {
        rowHeight = rowHeight + USERNAME_HEIGHT;
    }
    
    _cellHeight = rowHeight;
    
    [self updateDatabaseMessageHeightAndWidthWithRowHeight:rowHeight];
    CGFloat height = _cellHeight;
    if (_showMessageTime) {
        height += SHOW_MESSAGE_TIME_HEIGHT;
    }
    // 通知聊天界面刷新这个消息
    [IMNotificationCenter postNotificationName:@"updateRowHeight" object:nil userInfo:@{@"messageId":self.messageId, @"cellHeight":@(height), @"messageSize":@(_messageSize)}];
    
    if (complete) {
        
        if (_showMessageTime && !_updatedRowHeight) {
            _cellHeight += SHOW_MESSAGE_TIME_HEIGHT;
        }
        complete(_cellHeight, messageSize, YES);
    }
}




/**
 CoreDataObject  转换为model
 
 @param obj 当前需要转换的字典
 @param complete 其他操作回调
 @return 返回一个由CoreDataObject 转换为 Model 的MessgaeModel
 */
+ (IMMessageModel *)modelWithCoreDataObject:(XMPPMessageArchiving_Message_CoreDataObject *)obj complete:(IMMessageModel * _Nonnull (^)(IMMessageModel *objModel,XMPPMessageArchiving_Message_CoreDataObject *obj))complete{
    
    XMPPMessage *message = obj.message;
    NSString *str = [[message elementForName:kMessageElementDataBodyName] stringValue];
    NSDictionary *objDict = [NSDictionary dictionaryWithJsonString:str];
    IMMessageModel *model  = [IMMessageModel new];
    if (objDict.count > 0) {
        model.messageId       = objDict[msg_id_key];
        model.msgType         = [objDict[msg_type_key] intValue];
        model.messageChatType = [objDict[chat_type_key] intValue];
        model.content         = objDict[msg_content_key];
        model.recvTime        = objDict[send_time_key];
    }
    if (model.content == nil) {
        model.content = obj.message.body;
    }
    
    if (model.recvTime.length == 0) {
        model.recvTime = [NSDate getNowTimestamp:obj.timestamp];
    }
    
    model.direction = obj.isOutgoing?IMMessageSenderTypeSender:IMMessageSenderTypeReceiver;
    model.aotoResend = model.messageSendStatus == IMMessageSendStatusSending;
    if (model.msgType == IMMessageTypeText) {
        CGSize messageSize = [model.messageAtt boundingRectWithSize:CGSizeMake(ceil(MESSAGE_MAX_WIDTH)-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        messageSize = CGSizeMake(ceil(messageSize.width) + 10, ceil(messageSize.height) + 16);
        if (model.messageSize.width != messageSize.width || model.messageSize.height != messageSize.height) {
            model.cellHeight = -1;
            model.messageSize = CGSizeMake(-1, -1);
        }
    }
    
    if (complete) {
        IMMessageModel *completeModel  = complete(model,obj);
        if (completeModel) {
            model = completeModel;
        }
    }
    
    return model;
}
@end