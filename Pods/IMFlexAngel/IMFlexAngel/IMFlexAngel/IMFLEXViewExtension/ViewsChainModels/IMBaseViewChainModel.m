//
//  IMBaseViewChainModel.m
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import "IMBaseViewChainModel.h"
#import "UIView+IMFrame.h"
//#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
//#endif

#define     IMFLEX_CHAIN_VIEW_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, id, UIView)

#define     IMFLEX_CHAIN_MASONRY_IMPLEMENTATION(methodName, masonryMethod) \
- (id (^)( void (^constraints)(MASConstraintMaker *)) )methodName    \
{   \
return ^id ( void (^constraints)(MASConstraintMaker *) ) {  \
if (self.view.superview) { \
[self.view masonryMethod:constraints];    \
}   \
return self;    \
};  \
}

#define     IMFLEX_CHAIN_MASONRY_IMPLEMENTATION_NULL(methodName, masonryMethod) \
- (id (^)( void (^constraints)(MASConstraintMaker *)) )methodName    \
{   \
return ^id ( void (^constraints)(MASConstraintMaker *) ) {  \
return self;    \
};  \
}

#define     IMFLEX_CHAIN_LAYER_IMPLEMENTATION(methodName, IMParamType) \
- (id (^)(IMParamType param))methodName    \
{   \
return ^id (IMParamType param) {    \
self.view.layer.methodName = param;   \
return self;    \
};\
}

@implementation IMBaseViewChainModel

- (id)initWithTag:(NSInteger)tag andView:(__kindof UIView *)view
{
    if (self = [super init]) {
        _tag = tag;
        _view = view;
        [view setTag:tag];
    }
    return self;
}

#pragma mark - # Frame
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(frame, CGRect);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(origin, CGPoint);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(x, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(y, CGFloat);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(size, CGSize);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(width, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(height, CGFloat);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(center, CGPoint);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(centerX, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(centerY, CGFloat);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(top, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(bottom, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(left, CGFloat);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(right, CGFloat);


#pragma mark - # Layout
//#if __has_include(<Masonry/Masonry.h>)
IMFLEX_CHAIN_MASONRY_IMPLEMENTATION(masonry, mas_makeConstraints);
IMFLEX_CHAIN_MASONRY_IMPLEMENTATION(updateMasonry, mas_updateConstraints);
IMFLEX_CHAIN_MASONRY_IMPLEMENTATION(remakeMasonry, mas_remakeConstraints);
//#else
//IMFLEX_CHAIN_MASONRY_IMPLEMENTATION_NULL(masonry, mas_makeConstraints);
//IMFLEX_CHAIN_MASONRY_IMPLEMENTATION_NULL(updateMasonry, mas_updateConstraints);
//IMFLEX_CHAIN_MASONRY_IMPLEMENTATION_NULL(remakeMasonry, mas_remakeConstraints);
//#endif

#pragma mark - # Color
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(backgroundColor, UIColor *);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(tintColor, UIColor *);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(alpha, CGFloat);


#pragma mark - # Control
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(contentMode, UIViewContentMode);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(opaque, BOOL);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(hidden, BOOL);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(clipsToBounds, BOOL);

IMFLEX_CHAIN_VIEW_IMPLEMENTATION(userInteractionEnabled, BOOL);
IMFLEX_CHAIN_VIEW_IMPLEMENTATION(multipleTouchEnabled, BOOL);


#pragma mark - # Layer
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(masksToBounds, BOOL);

- (id (^)(CGFloat cornerRadius))cornerRadius
{
    return ^__kindof IMBaseViewChainModel *(CGFloat cornerRadius) {
        [self.view.layer setMasksToBounds:YES];
        [self.view.layer setCornerRadius:cornerRadius];
        return self;
    };
}

- (id (^)(CGFloat borderWidth, UIColor *borderColor))border
{
    return ^__kindof IMBaseViewChainModel *(CGFloat borderWidth, UIColor *borderColor) {
        [self.view.layer setBorderWidth:borderWidth];
        [self.view.layer setBorderColor:borderColor.CGColor];
        return self;
    };
}
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(borderWidth, CGFloat);
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(borderColor, CGColorRef);

IMFLEX_CHAIN_LAYER_IMPLEMENTATION(zPosition, CGFloat);
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(anchorPoint, CGPoint);

- (id (^)(CGSize shadowOffset, CGFloat shadowRadius, UIColor *shadowColor, CGFloat shadowOpacity))shadow
{
    return ^__kindof IMBaseViewChainModel *(CGSize shadowOffset, CGFloat shadowRadius, UIColor *shadowColor, CGFloat shadowOpacity) {
        [self.view.layer setShadowOffset:shadowOffset];
        [self.view.layer setShadowRadius:shadowRadius];
        [self.view.layer setShadowColor:shadowColor.CGColor];
        [self.view.layer setShadowOpacity:shadowOpacity];
        return self;
    };
}
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(shadowColor, CGColorRef);
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(shadowOpacity, CGFloat);
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(shadowOffset, CGSize);
IMFLEX_CHAIN_LAYER_IMPLEMENTATION(shadowRadius, CGFloat);


IMFLEX_CHAIN_LAYER_IMPLEMENTATION(transform, CATransform3D);

@end

