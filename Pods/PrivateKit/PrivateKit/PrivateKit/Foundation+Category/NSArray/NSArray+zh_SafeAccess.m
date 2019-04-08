//
//  NSArray+zh_SafeAccess.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSArray+zh_SafeAccess.h"

@implementation NSArray (zh_SafeAccess)
- (NSUInteger)zh_indexOfObject:(id)anObject {
    NSParameterAssert(self.count);
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

- (id)zh_objectOfIndex:(NSInteger)index{
    if (index < 0 || index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (id)zh_objectOfBlock:(id(^)(id value))block {
    for (id sub in self) {
        if (block) {
            id returnValue = block(sub);
            if (returnValue) return returnValue;
        }
    }
    return nil;
}

- (NSArray *)zh_objectsArrayOfBlock:(id(^)(id value))block{
    NSParameterAssert(self.count);
    NSMutableArray *array = [NSMutableArray array];
    for (id sub in self) {
        if (block) {
            id returnValue = block(sub);
            if (returnValue) [array addObject:returnValue];
        }
    }
    return array;
}

///  删除指定条件object
- (id)zh_removeOfObject:(BOOL(^)(id value))block
{
    NSParameterAssert(self.count);
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj  in self) {
        BOOL  isremove = block(obj);
        if (isremove == NO) {
            [arr addObject:obj];
        }
    }
    return arr;
}

///  替换指定条件Object
- (NSArray *)zh_replaceOfObject:(id(^)(id value))block
{
    NSParameterAssert(self.count);
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj  in self) {
        id isreplace = block(obj);
        if (isreplace) {
            [arr addObject:isreplace];
        }else{
            [arr addObject:obj];
        }
    }
    return arr;
}

///  遍历数组并且返回一个处理后的新数组
- (NSArray *)zh_enumerateObjectsUsingBlock:(id(^)(id obj))block{
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id model = block(obj);
        if (model) {
            [array addObject:model];
        }
    }];
    return array;
}

- (NSArray *)zh_SortObjectsUsingBlock:(BOOL(^)(id obj1,id obj2))block{
    NSArray *result = [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return block(obj1,obj2);
    }];
    return result;
}

///  这个方法可以获取到html中的所有图片
+ (NSArray *)zh_getAllImgOfHtml:(NSString *)webString{
    if (webString.length==0) {
        return nil;
    }
    NSString *webStr  = [NSString stringWithFormat:@"%@",webString];
    NSMutableArray *imageurlArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *rangeArr = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webStr options:0 range:NSMakeRange(0, [webString length] - 1)];
    for (NSTextCheckingResult * result in match) {
        //过去数组中的标签
        NSRange range = [result range];
        [rangeArr addObject:NSStringFromRange(range)];
        NSString * subString = [webStr substringWithRange:range];
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    
    return imageurlArray;
}

///  用指定字符串连接
- (id)zh_Join:(NSString *)joinStr{
    NSParameterAssert(joinStr);
    return [self componentsJoinedByString:joinStr];
}

@end
