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

@end

@implementation NSString (pinyin)
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



@implementation NSString (URL)

- (NSURL *)toURL
{
    if (self.length > 0) {
        return [NSURL URLWithString:self];
    }
    return nil;
}

#pragma mark - # 编码
- (NSString *)urlEncode
{
    NSString *urlString = [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    NSString *urlString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                (__bridge CFStringRef)self,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                CFStringConvertNSStringEncodingToEncoding(encoding));
    return urlString;
}

#pragma mark - # 解码
- (NSString *)urlDecode
{
    NSString *urlString = [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding
{
    NSString *urlString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                (__bridge CFStringRef)self,
                                                                                                                CFSTR(""),
                                                                                                                CFStringConvertNSStringEncodingToEncoding(encoding));
    return urlString;
}


#pragma mark - # url解析
- (NSDictionary *)dictionaryFromURLParameters
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


@end
