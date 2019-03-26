//
//  IMNetworking.h
//  MYIMDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019 徐世杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IMHTTPRequest/IMNetWorkHelper.h>

NS_ASSUME_NONNULL_BEGIN
@class IMNetworkingResult;
/**
 请求成功的block
 */
typedef void(^YSFRequestSuccess)(IMNetworkingResult *result);
typedef void(^YSFRequestSuccessAndCache)(IMNetworkingResult *result,BOOL isCache);
/**
 请求失败的block
 */
typedef void(^YSFRequestFailure)(NSError *error);


@interface IMNetworkingResult : NSObject

@property (strong, nonatomic) NSString  *msg;
@property (assign, nonatomic) NSInteger     status;
@property (strong, nonatomic) id       data;
@property (strong, nonatomic) id       json;
- (id)objectForKey:(NSString *)key;
- (id)initWithJSON:(id)json;
@end


@interface IMNetworking : NSObject
#pragma mark - 登陆退出
/** 登录*/
/*
 + (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;
 */
/** 退出*/
/*
 + (NSURLSessionTask *)getExitWithParameters:(id)parameters success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;
 */


/**
 获取缓存
 */
+ (id)cacheWithURL:(NSString *)URL parameters:(NSDictionary *)parameter;

/*
 配置好YSFNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用YSFNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 以下是无缓存的公共方法,可自己再定制有缓存的
 */
+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(YSFRequestSuccessAndCache)success failure:(YSFRequestFailure)failure isResponseCache:(BOOL)isResponseCache;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(YSFRequestSuccessAndCache)success failure:(YSFRequestFailure)failure isResponseCache:(BOOL)isResponseCache ;


+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;

+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(YSFRequestSuccess)responseCache success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(YSFRequestSuccess)responseCache success:(YSFRequestSuccess)success failure:(YSFRequestFailure)failure;

/**
 上传图片
 
 @param module 模块儿（装修圈：forum，效果图：effect ，头像：avatar， 活动：user_active）
 @param imageArray 图片数组
 @param progress 加载进度的回调
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void )uploadWithModule:(NSString *)module
               imageArray:(NSArray<UIImage *> *)imageArray
                 progress:(void (^)(NSProgress *progress,UIImage *image))progress
                  success:(void (^)(NSArray *urls,NSArray *imgs))success
                  failure:(YSFRequestFailure)failure;

/**
 下载文件
 
 @param url 下载链接
 @param fileDir 保存在缓存目录下
 @param progressBlock 下载进度
 @param success 成功后的回调
 @param failure 失败的回调
 */
+ (void)downFileWithUrl:(NSString *)url
                filrDir:(NSString *)fileDir
               progress:(void (^)(NSProgress *progress))progressBlock
                success:(void (^)(NSString *filePath))success
                failure:(YSFRequestFailure)failure;
@end


NS_ASSUME_NONNULL_END
