//
//  IMTextFieldChainModel.h
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2017/12/9.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMTextFieldChainModel;
@interface IMTextFieldChainModel : IMBaseViewChainModel <IMTextFieldChainModel *>

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ text)(NSString *text);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ attributedText)(NSAttributedString *attributedText);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ font)(UIFont *font);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ textColor)(UIColor *textColor);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ textAlignment)(NSTextAlignment textAlignment);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ borderStyle)(UITextBorderStyle borderStyle);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ defaultTextAttributes)(NSDictionary *defaultTextAttributes);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ placeholder)(NSString *placeholder);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ attributedPlaceholder)(NSAttributedString *attributedPlaceholder);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ keyboardType)(UIKeyboardType keyboardType);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ clearsOnBeginEditing)(BOOL clearsOnBeginEditing);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ adjustsFontSizeToFitWidth)(BOOL adjustsFontSizeToFitWidth);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ minimumFontSize)(CGFloat minimumFontSize);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ delegate)(id<UITextFieldDelegate> delegate);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ background)(UIImage *background);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ disabledBackground)(UIImage *disabledBackground);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ allowsEditingTextAttributes)(BOOL allowsEditingTextAttributes);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ typingAttributes)(NSDictionary *typingAttributes);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ clearButtonMode)(UITextFieldViewMode clearButtonMode);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ leftView)(UIView *leftView);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ leftViewMode)(UITextFieldViewMode leftViewMode);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ rightView)(UIView *rightView);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ rightViewMode)(UITextFieldViewMode rightViewMode);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ inputView)(UIView *inputView);
IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ inputAccessoryView)(UIView *inputAccessoryView);

IMFLEX_CHAIN_PROPERTY IMTextFieldChainModel *(^ eventBlock)(UIControlEvents controlEvents, void (^eventBlock)(id sender));

@end

IMFLEX_EX_INTERFACE(UITextField, IMTextFieldChainModel)
