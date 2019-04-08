//
//  IMMoreKeyboardItem.h
//  IMChat
//
//  Created by 徐世杰 on 16/2/18.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IMMoreKeyboardItemType) {
    IMMoreKeyboardItemTypeImage,
    IMMoreKeyboardItemTypeCamera,
    IMMoreKeyboardItemTypeVideo,
    IMMoreKeyboardItemTypeVideoCall,
    IMMoreKeyboardItemTypeWallet,
    IMMoreKeyboardItemTypeTransfer,
    IMMoreKeyboardItemTypePosition,
    IMMoreKeyboardItemTypeFavorite,
    IMMoreKeyboardItemTypeBusinessCard,
    IMMoreKeyboardItemTypeVoice,
    IMMoreKeyboardItemTypeCards,
};

@interface IMMoreKeyboardItem : NSObject

@property (nonatomic, assign) IMMoreKeyboardItemType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *imagePath;

+ (IMMoreKeyboardItem *)createByType:(IMMoreKeyboardItemType)type title:(NSString *)title imagePath:(NSString *)imagePath;

@end
