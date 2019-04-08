//
//  IMUserGroupCell.h
//  IMChat
//
//  Created by 徐世杰 on 16/3/6.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMUserGroupCellEventType) {
    IMUserGroupCellEventTypeAdd,
    IMUserGroupCellEventTypeClickUser,
};

@interface IMUserGroupCell : UICollectionViewCell <IMFlexibleLayoutViewProtocol>

@property (nonatomic, copy) id (^eventAction)(IMUserGroupCellEventType eventType, id data);

@property (nonatomic, strong) NSMutableArray *users;


@end
