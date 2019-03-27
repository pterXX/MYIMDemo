//
//  IMRequestMacros.h
//  IMChat
//
//  Created by 李伯坤 on 2017/7/13.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#ifndef IMRequestMacros_h
#define IMRequestMacros_h

typedef NS_ENUM(NSInteger, IMRequestMethod) {
    /**
     * GET请求会显示请求指定的资源。一般来说GET方法应该只用于数据的读取，而不应当用于会产生副作用的非幂等的操作中。
     */
    IMRequestMethodGET = 0,
    /**
     * POST请求会向指定资源提交数据，请求服务器进行处理，如：表单数据提交、文件上传等，请求数据会被包含在请求体中。POST方法是非幂等的方法，因为这个请求可能会创建新的资源或/和修改现有资源。
     */
    IMRequestMethodPOST,
    /**
     * HEAD方法与GET方法一样，都是向服务器发出指定资源的请求。但是，服务器在响应HEAD请求时不会回传资源的内容部分，即：响应主体。这样，我们可以不传输全部内容的情况下，就可以获取服务器的响应头信息。HEAD方法常被用于客户端查看服务器的性能。
     */
    IMRequestMethodHEAD,
    /**
     * PUT请求会身向指定资源位置上传其最新内容，PUT方法是幂等的方法。通过该方法客户端可以将指定资源的最新数据传送给服务器取代指定的资源的内容。
     */
    IMRequestMethodPUT,
    /**
     * DELETE请求用于请求服务器删除所请求URI（统一资源标识符，Uniform Resource Identifier）所标识的资源。DELETE请求后指定资源会被删除，DELETE方法也是幂等的。
     */
    IMRequestMethodDELETE,
    /**
     * OPTIONS请求与HEAD类似，一般也是用于客户端查看服务器的性能。 这个方法会请求服务器返回该资源所支持的所有HTTP请求方法，该方法会用'*'来代替资源名称，向服务器发送OPTIONS请求，可以测试服务器功能是否正常。
     */
    IMRequestMethodOPTIONS,
    /**
     * PATCH方法出现的较晚，它在2010年的RFC 5789标准中被定义。PATCH请求与PUT请求类似，同样用于资源的更新。二者有以下两点不同：
     *
     * PATCH一般用于资源的部分更新，而PUT一般用于资源的整体更新。
     * 当资源不存在时，PATCH会创建一个新的资源，而PUT只会对已在资源进行更新。
     */
    IMRequestMethodPATCH,
    /**
     * CONNECT方法是HTTP/1.1协议预留的，能够将连接改为管道方式的代理服务器。通常用于SSL加密服务器的链接与非加密的HTTP代理服务器的通信。
     */
    IMRequestMethodCONNECT,
    /**
     * TRACE请求服务器回显其收到的请求信息，该方法主要用于HTTP请求的测试或诊断。
     */
    IMRequestMethodTRACE
};

typedef NS_ENUM(NSInteger, IMRequestSerializerType) {
    IMRequestSerializerTypeHTTP,
    IMRequestSerializerTypeJSON,
    IMRequestSerializerTypePLIST
};

typedef NS_ENUM(NSInteger, IMResponseSerializerType) {
    IMResponseSerializerTypeHTTP,
    IMResponseSerializerTypeJSON,
    IMResponseSerializerTypeXML,
    IMResponseSerializerTypePLIST
};

typedef NS_ENUM(NSInteger, IMRequestPriority) {
    IMRequestPriorityLow = -4L,
    IMRequestPriorityDefault = 0L,
    IMRequestPriorityHigh = 4L
};

typedef NS_ENUM(NSInteger, IMRequestState) {
    IMRequestStateRunning,
    IMRequestStateSuspended,
    IMRequestStateCanceling,
    IMRequestStateCompleted,
};

@class IMBaseRequest;
@class IMResponse;
typedef void (^IMRequestCompletionBlock)(IMResponse *response);
typedef void (^IMRequestSuccessBlock)(id successData);
typedef void (^IMRequestFailureBlock)(id failureData);

@protocol AFMultipartFormData;
typedef void (^IMConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^IMRequestProgressBlock)(NSProgress *progress);

@protocol IMRequestDelegate <NSObject>

- (void)requestSuccess:(__kindof IMBaseRequest *)requestModel withResponseModel:(IMResponse *)responseModel;

- (void)requestFailure:(__kindof IMBaseRequest *)requestModel withResponseModel:(IMResponse *)responseModel;

@end

#endif /* IMRequestMacros_h */
