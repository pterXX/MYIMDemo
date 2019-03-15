//
//  IMContactsHeaderView.h
//  IMChat
//
//  Created by 李伯坤 on 16/1/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFlexibleLayoutViewProtocol.h"

@interface IMContactsHeaderView : UITableViewHeaderFooterView <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) NSString *title;

@end
