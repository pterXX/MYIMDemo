//
//  IMButtonChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMButtonChainModel.h"
#import "UIControl+IMEvent.h"
#import "UIButton+IMExtension.h"

#define     IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMButtonChainModel *, UIButton)

#define     IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, IMParamType, Code, State)    \
- (IMButtonChainModel *(^)(IMParamType param))methodName   \
{   \
    return ^IMButtonChainModel *(IMParamType param) {     \
        [(UIButton *)self.view Code:param forState:State];      \
        return self;        \
    };      \
}       \

#define     IMFLEX_CHAIN_BUTTON_TITLE_IMPLEMENTATION(methodName, State)             IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, NSString *, setTitle, State)
#define     IMFLEX_CHAIN_BUTTON_TITLECOLOR_IMPLEMENTATION(methodName, State)        IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, UIColor *, setTitleColor, State)
#define     IMFLEX_CHAIN_BUTTON_SHADOW_IMPLEMENTATION(methodName, State)            IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, UIColor *, setTitleShadowColor, State)
#define     IMFLEX_CHAIN_BUTTON_IMAGE_IMPLEMENTATION(methodName, State)             IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, UIImage *, setImage, State)
#define     IMFLEX_CHAIN_BUTTON_BGIMAGE_IMPLEMENTATION(methodName, State)           IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, UIImage *, setBackgroundImage, State)
#define     IMFLEX_CHAIN_BUTTON_ATTRTITLE_IMPLEMENTATION(methodName, State)         IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, NSAttributedString *, setAttributedTitle, State)
#define     IMFLEX_CHAIN_BUTTON_BGCOLOR_IMPLEMENTATION(methodName, State)           IMFLEX_CHAIN_BUTTON_STATE_IMPLEMENTATION(methodName, UIColor *, setBackgroundColor, State)

@implementation IMButtonChainModel

IMFLEX_CHAIN_BUTTON_TITLE_IMPLEMENTATION(title, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_TITLE_IMPLEMENTATION(titleHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_TITLE_IMPLEMENTATION(titleSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_TITLE_IMPLEMENTATION(titleDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_TITLECOLOR_IMPLEMENTATION(titleColor, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_TITLECOLOR_IMPLEMENTATION(titleColorHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_TITLECOLOR_IMPLEMENTATION(titleColorSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_TITLECOLOR_IMPLEMENTATION(titleColorDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_SHADOW_IMPLEMENTATION(titleShadowColor, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_SHADOW_IMPLEMENTATION(titleShadowColorHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_SHADOW_IMPLEMENTATION(titleShadowColorSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_SHADOW_IMPLEMENTATION(titleShadowColorDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_IMAGE_IMPLEMENTATION(image, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_IMAGE_IMPLEMENTATION(imageHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_IMAGE_IMPLEMENTATION(imageSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_IMAGE_IMPLEMENTATION(imageDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_BGIMAGE_IMPLEMENTATION(backgroundImage, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_BGIMAGE_IMPLEMENTATION(backgroundImageHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_BGIMAGE_IMPLEMENTATION(backgroundImageSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_BGIMAGE_IMPLEMENTATION(backgroundImageDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_ATTRTITLE_IMPLEMENTATION(attributedTitle, UIControlStateNormal);
IMFLEX_CHAIN_BUTTON_ATTRTITLE_IMPLEMENTATION(attributedTitleHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_ATTRTITLE_IMPLEMENTATION(attributedTitleSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_ATTRTITLE_IMPLEMENTATION(attributedTitleDisabled, UIControlStateDisabled);

IMFLEX_CHAIN_BUTTON_BGCOLOR_IMPLEMENTATION(backgroundColorHL, UIControlStateHighlighted);
IMFLEX_CHAIN_BUTTON_BGCOLOR_IMPLEMENTATION(backgroundColorSelected, UIControlStateSelected);
IMFLEX_CHAIN_BUTTON_BGCOLOR_IMPLEMENTATION(backgroundColorDisabled, UIControlStateDisabled);

- (IMButtonChainModel *(^)(UIFont *titleFont))titleFont
{
    return ^IMButtonChainModel *(UIFont *titleFont) {
        ((UIButton *)self.view).titleLabel.font = titleFont;
        return self;
    };
}

IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(contentEdgeInsets, UIEdgeInsets);
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(titleEdgeInsets, UIEdgeInsets);
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(imageEdgeInsets, UIEdgeInsets);


#pragma mark - # UIControl
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(enabled, BOOL);
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(selected, BOOL);
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(highlighted, BOOL);

- (IMButtonChainModel *(^)(UIControlEvents controlEvents, void (^eventBlock)(id sender)))eventBlock
{
    return ^IMButtonChainModel *(UIControlEvents controlEvents, void (^eventBlock)(id sender)) {
        [(UIControl *)self.view addControlEvents:controlEvents handler:eventBlock];
        return self;
    };
}

IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(contentVerticalAlignment, UIControlContentVerticalAlignment);
IMFLEX_CHAIN_BUTTON_IMPLEMENTATION(contentHorizontalAlignment, UIControlContentHorizontalAlignment);

@end

IMFLEX_EX_IMPLEMENTATION(UIButton, IMButtonChainModel)
