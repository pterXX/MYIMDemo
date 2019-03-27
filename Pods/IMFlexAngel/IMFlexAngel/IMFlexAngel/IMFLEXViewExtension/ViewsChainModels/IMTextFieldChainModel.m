//
//  IMTextFieldChainModel.m
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/9.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMTextFieldChainModel.h"
#import "UIControl+IMEvent.h"

#define     IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMTextFieldChainModel *, UITextField)
@implementation IMTextFieldChainModel

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(text, NSString *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(attributedText, NSAttributedString *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(font, UIFont *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(textColor, UIColor *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(textAlignment, NSTextAlignment);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(borderStyle, UITextBorderStyle);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(defaultTextAttributes, NSDictionary *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(placeholder, NSString *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(attributedPlaceholder, NSAttributedString *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(keyboardType, UIKeyboardType);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(clearsOnBeginEditing, BOOL);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(adjustsFontSizeToFitWidth, BOOL);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(minimumFontSize, CGFloat);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(delegate, id<UITextFieldDelegate>);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(background, UIImage *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(disabledBackground, UIImage *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(allowsEditingTextAttributes, BOOL);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(typingAttributes, NSDictionary *);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(clearButtonMode, UITextFieldViewMode);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(leftView, UIView *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(leftViewMode, UITextFieldViewMode);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(rightView, UIView *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(rightViewMode, UITextFieldViewMode);

IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(inputView, UIView *);
IMFLEX_CHAIN_TEXTFIELD_IMPLEMENTATION(inputAccessoryView, UIView *);

- (IMTextFieldChainModel *(^)(UIControlEvents controlEvents, void (^eventBlock)(id sender)))eventBlock
{
    return ^IMTextFieldChainModel *(UIControlEvents controlEvents, void (^eventBlock)(id sender)) {
        [(UIControl *)self.view addControlEvents:controlEvents handler:eventBlock];
        return self;
    };
}

@end

IMFLEX_EX_IMPLEMENTATION(UITextField, IMTextFieldChainModel)
