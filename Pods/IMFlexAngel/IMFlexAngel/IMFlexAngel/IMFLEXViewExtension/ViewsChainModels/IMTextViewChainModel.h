//
//  IMTextViewChainModel.h
//  IMFLEXDemo
//
//  Created by 李伯坤 on 2018/1/24.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "IMBaseViewChainModel.h"

@class IMTextViewChainModel;
@interface IMTextViewChainModel : IMBaseViewChainModel <IMTextViewChainModel *>

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ delegate)(id<UITextViewDelegate> delegate);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ text)(NSString *text);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ font)(UIFont *font);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ textColor)(UIColor *textColor);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ textAlignment)(NSTextAlignment textAlignment);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ selectedRange)(NSRange numberOfLines);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ editable)(BOOL editable);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ selectable)(BOOL selectable);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ dataDetectorTypes)(UIDataDetectorTypes dataDetectorTypes);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ keyboardType)(UIKeyboardType keyboardType);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ allowsEditingTextAttributes)(BOOL allowsEditingTextAttributes);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ attributedText)(NSAttributedString *attributedText);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ typingAttributes)(NSDictionary *typingAttributes);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ clearsOnInsertion)(BOOL clearsOnInsertion);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ textContainerInset)(UIEdgeInsets textContainerInset);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ linkTextAttributes)(NSDictionary *linkTextAttributes);

#pragma mark - UIScrollView
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ contentSize)(CGSize contentSize);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ contentOffset)(CGPoint contentOffset);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ contentInset)(UIEdgeInsets contentInset);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ bounces)(BOOL bounces);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ alwaysBounceVertical)(BOOL alwaysBounceVertical);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ alwaysBounceHorizontal)(BOOL alwaysBounceHorizontal);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ pagingEnabled)(BOOL pagingEnabled);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ scrollEnabled)(BOOL scrollEnabled);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ showsHorizontalScrollIndicator)(BOOL showsHorizontalScrollIndicator);
IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ showsVerticalScrollIndicator)(BOOL showsVerticalScrollIndicator);

IMFLEX_CHAIN_PROPERTY IMTextViewChainModel *(^ scrollsToTop)(BOOL scrollsToTop);

@end

IMFLEX_EX_INTERFACE(UITextView, IMTextViewChainModel)
