//
//  NSString+Category.m
//  RChat
//
//  Created by eims on 2018/9/4.
//  Copyright © 2018年 RPK. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

// 判断字符串是否是全空格
- (BOOL)isEmptyString
{
    if (!self || !self.length)
    {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *isString = [self stringByTrimmingCharactersInSet:set];
        
        if ([isString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}


- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    if (self.length == 0) {
        return nil;
    }
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    
    return initial;
}
@end
