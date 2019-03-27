//
//  IMChatMessageDisplayView+Delegate.h
//  IMChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "IMChatMessageDisplayView.h"
#import "IMTextMessageCell.h"
#import "IMImageMessageCell.h"
#import "IMExpressionMessageCell.h"
#import "IMVoiceMessageCell.h"

@interface IMChatMessageDisplayView (Delegate) <UITableViewDelegate, UITableViewDataSource, IMMessageCellDelegate, IMActionSheetDelegate>

- (void)registerCellClassForTableView:(UITableView *)tableView;

@end
