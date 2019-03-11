//
//  IMAddressBookTableViewCell.h
//  MYIMDemo
//
//  Created by admin on 2019/3/11.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMAddressBookTableViewCell : IMBaseTableViewCell
@property (nonatomic, strong) UILabel       *titleLabel;        /**< 标题 */
@property (nonatomic, strong) UIImageView   *avaterImageView;   /**< 用户头像 */

+ (CGFloat)cellLayoutHeight;
@end

NS_ASSUME_NONNULL_END
