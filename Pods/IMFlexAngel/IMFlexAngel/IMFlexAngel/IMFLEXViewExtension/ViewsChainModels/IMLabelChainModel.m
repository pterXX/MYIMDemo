//
//  IMLabelChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMLabelChainModel.h"

#define     IMFLEX_CHAIN_LABEL_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMLabelChainModel *, UILabel)

@implementation IMLabelChainModel

IMFLEX_CHAIN_LABEL_IMPLEMENTATION(text, NSString *);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(font, UIFont *);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(textColor, UIColor *);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(attributedText, NSAttributedString *);

IMFLEX_CHAIN_LABEL_IMPLEMENTATION(textAlignment, NSTextAlignment);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(numberOfLines, NSInteger);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(lineBreakMode, NSLineBreakMode);
IMFLEX_CHAIN_LABEL_IMPLEMENTATION(adjustsFontSizeToFitWidth, BOOL);

@end

IMFLEX_EX_IMPLEMENTATION(UILabel, IMLabelChainModel)
