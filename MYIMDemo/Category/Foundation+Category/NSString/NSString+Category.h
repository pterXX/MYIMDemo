//
//  NSString+Category.h
//  RChat
//
//  Created by eims on 2018/9/4.
//  Copyright © 2018年 RPK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
// 判断字符串是否是全空格
- (BOOL)isEmptyString;

@end

@interface NSString (pinyin)
//  拼音
- (NSString *)pinyin;
- (NSString *)pinyinInitial;
@end


@interface NSString (URL)
@property (nonatomic, strong, readonly) NSURL *toURL;

#pragma mark - # 编码
/**
 *  url编码，使用 NSUTF8StringEncoding 格式
 *
 *  @return encode后的字符串
 */
- (NSString *)urlEncode;

/**
 *  url编码
 *
 *  @param encoding 编码模式
 *
 *  @return encode后的字符串
 */
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;


#pragma mark - # 解码
/**
 *  url解码，使用 NSUTF8StringEncoding 格式
 *
 *  @return decode后的字符串
 */
- (NSString *)urlDecode;

/**
 *  url解码
 *
 *  @param encoding 编码模式
 *
 *  @return decode后的字符串
 */
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;


#pragma mark - # url解析
/**
 *  将url中的参数转成dic
 */
- (NSDictionary *)dictionaryFromURLParameters;


@end
