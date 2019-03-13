//
//  IMNewContactTableViewCell.h
//  MYIMDemo
//
//  Created by admin on 2019/3/13.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import "IMAddressBookTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMNewContactTableViewCell : IMAddressBookTableViewCell
@property (nonatomic, strong) UIButton       *agreeBut;        /**< 同意按钮 */
@property (nonatomic, strong) UIButton       *rejectBut;       /**< 拒绝按钮 */
@property (nonatomic, strong) UIButton       *statusBut;       /**< 状态按钮 */
@end

NS_ASSUME_NONNULL_END
