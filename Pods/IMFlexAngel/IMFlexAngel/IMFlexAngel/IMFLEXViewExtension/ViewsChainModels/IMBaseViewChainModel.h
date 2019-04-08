//
//  IMBaseViewChainModel.h
//  zhuanzhuan
//
//  Created by 李伯坤 on 2017/10/24.
//  Copyright © 2017年 转转. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 链式API声明
#define     IMFLEX_CHAIN_PROPERTY               @property (nonatomic, copy, readonly)
/// 一般链式API实现
#define     IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMViewChainModelType, IMViewClass) \
- (IMViewChainModelType (^)(IMParamType param))methodName {   \
    return ^IMViewChainModelType (IMParamType param) {    \
        ((IMViewClass *)self.view).methodName = param;   \
        return self;    \
    };\
}

/// UIKit拓展声明
#define     IMFLEX_EX_INTERFACE(IMView, IMViewChainModelClass)   \
@interface IMView (IMFLEX_EX)   \
IMFLEX_CHAIN_PROPERTY IMViewChainModelClass *IM_make;    \
+ (IMViewChainModelClass *(^)(NSInteger tag))IM_create;   \
@end
/// UIKit拓展实现
#define     IMFLEX_EX_IMPLEMENTATION(IMView, IMViewChainModelClass) \
@implementation IMView (IMFLEX_EX)  \
+ (IMViewChainModelClass *(^)(NSInteger tag))IM_create {\
    return ^IMViewChainModelClass *(NSInteger tag){    \
        IMView *view = [[IMView alloc] init];   \
        return [[IMViewChainModelClass alloc] initWithTag:tag andView:view];    \
    };\
}\
- (IMViewChainModelClass *)IM_make {   \
    return [[IMViewChainModelClass alloc] initWithTag:self.tag andView:self];    \
}   \
@end

@class MASConstraintMaker;
@interface IMBaseViewChainModel <ObjcType> : NSObject

/// 视图的唯一标示
@property (nonatomic, assign, readonly) NSInteger tag;

/// 视图的唯一标示
@property (nonatomic, strong, readonly) __kindof UIView *view;

@property (nonatomic, assign, readonly) Class viewClass;

- (instancetype)initWithTag:(NSInteger)tag andView:(__kindof UIView *)view;

#pragma mark - # Frame
IMFLEX_CHAIN_PROPERTY ObjcType (^ frame)(CGRect frame);

IMFLEX_CHAIN_PROPERTY ObjcType (^ origin)(CGPoint origin);
IMFLEX_CHAIN_PROPERTY ObjcType (^ x)(CGFloat x);
IMFLEX_CHAIN_PROPERTY ObjcType (^ y)(CGFloat y);

IMFLEX_CHAIN_PROPERTY ObjcType (^ size)(CGSize size);
IMFLEX_CHAIN_PROPERTY ObjcType (^ width)(CGFloat width);
IMFLEX_CHAIN_PROPERTY ObjcType (^ height)(CGFloat height);

IMFLEX_CHAIN_PROPERTY ObjcType (^ center)(CGPoint center);
IMFLEX_CHAIN_PROPERTY ObjcType (^ centerX)(CGFloat centerX);
IMFLEX_CHAIN_PROPERTY ObjcType (^ centerY)(CGFloat centerY);

IMFLEX_CHAIN_PROPERTY ObjcType (^ top)(CGFloat top);
IMFLEX_CHAIN_PROPERTY ObjcType (^ bottom)(CGFloat bottom);
IMFLEX_CHAIN_PROPERTY ObjcType (^ left)(CGFloat left);
IMFLEX_CHAIN_PROPERTY ObjcType (^ right)(CGFloat right);

#pragma mark - # Layout
IMFLEX_CHAIN_PROPERTY ObjcType (^ masonry)( void (^constraints)(MASConstraintMaker *make) );
IMFLEX_CHAIN_PROPERTY ObjcType (^ updateMasonry)( void (^constraints)(MASConstraintMaker *make) );
IMFLEX_CHAIN_PROPERTY ObjcType (^ remakeMasonry)( void (^constraints)(MASConstraintMaker *make) );

#pragma mark - # Color
IMFLEX_CHAIN_PROPERTY ObjcType (^ backgroundColor)(UIColor *backgroundColor);
IMFLEX_CHAIN_PROPERTY ObjcType (^ tintColor)(UIColor *tintColor);
IMFLEX_CHAIN_PROPERTY ObjcType (^ alpha)(CGFloat alpha);

#pragma mark - # Control
IMFLEX_CHAIN_PROPERTY ObjcType (^ contentMode)(UIViewContentMode contentMode);

IMFLEX_CHAIN_PROPERTY ObjcType (^ opaque)(BOOL opaque);
IMFLEX_CHAIN_PROPERTY ObjcType (^ hidden)(BOOL hidden);
IMFLEX_CHAIN_PROPERTY ObjcType (^ clipsToBounds)(BOOL clipsToBounds);

IMFLEX_CHAIN_PROPERTY ObjcType (^ userInteractionEnabled)(BOOL userInteractionEnabled);
IMFLEX_CHAIN_PROPERTY ObjcType (^ multipleTouchEnabled)(BOOL multipleTouchEnabled);

#pragma mark - # Layer
IMFLEX_CHAIN_PROPERTY ObjcType (^ masksToBounds)(BOOL masksToBounds);
IMFLEX_CHAIN_PROPERTY ObjcType (^ cornerRadius)(CGFloat cornerRadius);

IMFLEX_CHAIN_PROPERTY ObjcType (^ border)(CGFloat borderWidth, UIColor *borderColor);
IMFLEX_CHAIN_PROPERTY ObjcType (^ borderWidth)(CGFloat borderWidth);
IMFLEX_CHAIN_PROPERTY ObjcType (^ borderColor)(CGColorRef borderColor);

IMFLEX_CHAIN_PROPERTY ObjcType (^ zPosition)(CGFloat zPosition);
IMFLEX_CHAIN_PROPERTY ObjcType (^ anchorPoint)(CGPoint anchorPoint);

IMFLEX_CHAIN_PROPERTY ObjcType (^ shadow)(CGSize shadowOffset, CGFloat shadowRadius, UIColor *shadowColor, CGFloat shadowOpacity);
IMFLEX_CHAIN_PROPERTY ObjcType (^ shadowColor)(CGColorRef shadowColor);
IMFLEX_CHAIN_PROPERTY ObjcType (^ shadowOpacity)(CGFloat shadowOpacity);
IMFLEX_CHAIN_PROPERTY ObjcType (^ shadowOffset)(CGSize shadowOffset);
IMFLEX_CHAIN_PROPERTY ObjcType (^ shadowRadius)(CGFloat shadowRadius);

IMFLEX_CHAIN_PROPERTY ObjcType (^ transform)(CATransform3D transform);

@end
