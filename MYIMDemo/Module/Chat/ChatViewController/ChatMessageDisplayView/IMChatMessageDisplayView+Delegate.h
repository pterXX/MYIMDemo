//
//  IMChatMessageDisplayView+Delegate.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/17.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMChatMessageDisplayView.h"
#import "IMTextMessageCell.h"
#import "IMImageMessageCell.h"
#import "IMExpressionMessageCell.h"
#import "IMVoiceMessageCell.h"

@interface IMChatMessageDisplayView (Delegate) <UITableViewDelegate, UITableViewDataSource, IMMessageCellDelegate, IMActionSheetDelegate>

- (void)registerCellClassForTableView:(UITableView *)tableView;

@end
