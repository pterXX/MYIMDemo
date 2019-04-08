//
//  IMContactsHeaderView.h
//  IMChat
//
//  Created by 徐世杰 on 16/1/26.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFlexibleLayoutViewProtocol.h"

@interface IMContactsHeaderView : UITableViewHeaderFooterView <IMFlexibleLayoutViewProtocol>

@property (nonatomic, strong) NSString *title;

@end
