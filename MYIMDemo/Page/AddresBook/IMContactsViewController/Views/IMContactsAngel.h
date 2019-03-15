//
//  IMContactsAngel.h
//  MYIMDemo
//
//  Created by admin on 2019/3/15.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMFlexAngel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, IMContactsVCSectionType) {
    IMContactsVCSectionTypeFuncation = -1,
    IMContactsVCSectionTypeEnterprise = -2,
};

typedef NS_ENUM(NSInteger, IMContactsVCCellType) {
    IMContactsVCCellTypeNew = -1,
    IMContactsVCCellTypeGroup = -2,
    IMContactsVCCellTypeTag = -3,
    IMContactsVCCellTypePublic = -4,
};


@interface IMContactsAngel : IMFlexAngel
/// pushAction
@property (nonatomic, copy) void (^pushAction)(__kindof UIViewController *vc);

- (void)resetListWithContactsData:(NSArray *)contactsData;

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *vc))pushAction;

@end

NS_ASSUME_NONNULL_END
