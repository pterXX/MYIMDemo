//
//  IMButtonChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMButtonChainModel;
@interface IMButtonChainModel : IMBaseViewChainModel<IMButtonChainModel *>

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ title)(NSString *title);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleHL)(NSString *titleHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleSelected)(NSString *titleSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleDisabled)(NSString *titleDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleColor)(UIColor *titleColor);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleColorHL)(UIColor *titleColorHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleColorSelected)(UIColor *titleColorSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleColorDisabled)(UIColor *titleColorDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleShadowColor)(UIColor *titleShadowColor);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleShadowColorHL)(UIColor *titleShadowColorHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleShadowColorSelected)(UIColor *titleShadowColorSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleShadowColorDisabled)(UIColor *titleShadowColorDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ image)(UIImage *image);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ imageHL)(UIImage *imageHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ imageSelected)(UIImage *imageSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ imageDisabled)(UIImage *imageDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundImage)(UIImage *backgroundImage);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundImageHL)(UIImage *backgroundImageHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundImageSelected)(UIImage *backgroundImageSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundImageDisabled)(UIImage *backgroundImageDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ attributedTitle)(NSAttributedString *attributedTitle);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ attributedTitleHL)(NSAttributedString *attributedTitleHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ attributedTitleSelected)(NSAttributedString *attributedTitleSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ attributedTitleDisabled)(NSAttributedString *attributedTitleDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundColorHL)(UIColor *backgroundColorHL);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundColorSelected)(UIColor *backgroundColorSelected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ backgroundColorDisabled)(UIColor *backgroundColorDisabled);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleFont)(UIFont *titleFont);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ contentEdgeInsets)(UIEdgeInsets contentEdgeInsets);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ titleEdgeInsets)(UIEdgeInsets titleEdgeInsets);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ imageEdgeInsets)(UIEdgeInsets imageEdgeInsets);

#pragma mark - # UIControl
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ enabled)(BOOL enabled);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ selected)(BOOL selected);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ highlighted)(BOOL highlighted);

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ eventBlock)(UIControlEvents controlEvents, void (^eventBlock)(id sender));

IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ contentVerticalAlignment)(UIControlContentVerticalAlignment contentVerticalAlignment);
IMFLEX_CHAIN_PROPERTY IMButtonChainModel *(^ contentHorizontalAlignment)(UIControlContentHorizontalAlignment contentHorizontalAlignment);


@end

IMFLEX_EX_INTERFACE(UIButton, IMButtonChainModel)
