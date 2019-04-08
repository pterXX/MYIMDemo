//
//  IMLabelChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMLabelChainModel;
@interface IMLabelChainModel : IMBaseViewChainModel <IMLabelChainModel *>

IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ text)(NSString *text);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ font)(UIFont *font);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ textColor)(UIColor *textColor);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ attributedText)(NSAttributedString *attributedText);

IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ textAlignment)(NSTextAlignment textAlignment);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ numberOfLines)(NSInteger numberOfLines);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ lineBreakMode)(NSLineBreakMode lineBreakMode);
IMFLEX_CHAIN_PROPERTY IMLabelChainModel *(^ adjustsFontSizeToFitWidth)(BOOL adjustsFontSizeToFitWidth);

@end

IMFLEX_EX_INTERFACE(UILabel, IMLabelChainModel)
