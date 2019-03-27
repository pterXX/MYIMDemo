//
//  IMSettingItem.h
//  IMChat
//
//  Created by 李伯坤 on 16/2/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     CELL_ST_ITEM_NORMAL                 @"IMSettingItemNormalCell"
#define     CELL_ST_ITEM_BUTTON                 @"IMSettingItemButtonCell"
#define     CELL_ST_ITEM_SWITCH                 @"IMSettingItemSwitchCell"
#define     VIEW_ST_HEADER                      @"IMSettingSectionHeaderView"
#define     VIEW_ST_FOOTER                      @"IMSettingSectionFooterView"


#define     IMCreateSettingItem(title)          [IMSettingItem createItemWithtitle:title]

typedef NS_ENUM(NSInteger, IMSettingItemType) {
    IMSettingItemTypeDefalut = 0,
    IMSettingItemTypetitleButton,
    IMSettingItemTypeSwitch,
    IMSettingItemTypeOther,
};

@interface IMSettingItem : NSObject


/**
 *  主标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *subtitle;

/**
 *  右图片(本地)
 */
@property (nonatomic, strong) NSString *rightImagePath;

/**
 *  右图片(网络)
 */
@property (nonatomic, strong) NSString *rightImageURL;

/**
 *  是否显示箭头（默认YES）
 */
@property (nonatomic, assign) BOOL showDisclosureIndicator;

/**
 *  停用高亮（默认NO）
 */
@property (nonatomic, assign) BOOL disableHighlight;

/**
 *  cell类型，默认default
 */
@property (nonatomic, assign) IMSettingItemType type;

+ (IMSettingItem *)createItemWithtitle:(NSString *)title;

- (NSString *) cellClassName;

@end
