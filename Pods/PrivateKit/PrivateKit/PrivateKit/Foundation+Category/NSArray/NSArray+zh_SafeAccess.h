//
//  NSArray+zh_SafeAccess.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSArray (zh_SafeAccess)

- (NSUInteger)zh_indexOfObject:(id _Nullable )anObject;
- (id)zh_objectOfIndex:(NSInteger)index;

///  获取指定条件的值
- (id)zh_objectOfBlock:(id(^)(id value))block;
- (NSArray *)zh_objectsArrayOfBlock:(id(^)(id value))block;

///  删除指定条件object
- (id _Nullable )zh_removeOfObject:(BOOL(^_Nonnull)(id _Nonnull value))block;

///  替换指定条件Object
- (NSArray *)zh_replaceOfObject:(id(^)(id value))block;

///  遍历数组并且返回一个处理后的新数组
- (NSArray *)zh_enumerateObjectsUsingBlock:(id(^)(id obj))block;

///  排序
- (NSArray *)zh_SortObjectsUsingBlock:(BOOL(^)(id obj1,id obj2))block;

///  这个方法可以获取到html中的所有图片
+ (NSArray *)zh_getAllImgOfHtml:(NSString *)webString;

///  用指定字符串连接
- (id)zh_Join:(NSString *)joinStr;
@end
NS_ASSUME_NONNULL_END
