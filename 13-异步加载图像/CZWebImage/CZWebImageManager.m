//
//  CZWebImageManager.m
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "CZWebImageManager.h"
#import "CZAdditions.h"


@interface CZWebImageManager()

// 图像缓存
@property (nonatomic, strong) NSMutableDictionary *imageCache;
// 下载操作缓存
@property (nonatomic, strong) NSMutableDictionary *operationCache;
// 下载队列
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation CZWebImageManager

+ (instancetype)sharedManger {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 在 init 方法中初始化队列和缓存
- (instancetype)init {
    self = [super init];
    if (self) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _imageCache = [NSMutableDictionary dictionary];
        _operationCache = [NSMutableDictionary dictionary];
    }
    return self;
}
/**
 *  异步执行的方法，不能通过返回值 返回结果，可以通过 block 回调 返回结果
 */
- (void)downloadImageWithURLString:(NSString *)urlString completion:(void (^)(UIImage *))completion {
    //0. 断言
    NSAssert(completion != nil, @"必须传入，完成回调");
    
    // 1. 内存缓存 key / urlString    value / image
    UIImage *cacheImage = _imageCache[urlString];
    if (cacheImage != nil) {
        completion(cacheImage);
        return;
    }
    
    // 2. 沙盒缓存
    cacheImage = [UIImage imageWithContentsOfFile:[self cachePathWithURLString:urlString]];
    if (cacheImage != nil) {
        // 设置内存缓存
        [_imageCache setObject:cacheImage forKey:urlString];
        // 完成回调
        completion(cacheImage);
        return;
    }
    
    // 3. 下载时间过长的话 防止重复添加操作，设置操作缓存,如果操作缓存存在，就直接返回
    if (_operationCache[urlString] != nil) {
        return;
    }
    
}
// 返回沙盒缓存文件全路劲
- (NSString *)cachePathWithURLString:(NSString *)urlString {
    
    // 1. 获取沙盒缓存路劲  cache
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    // 2. 将urlString 转换成 MD5 文件名
    NSString *fileName = [urlString cz_md5String];
    
    // 3.拼接完整文件的路劲
    NSString *path = [cacheDir stringByAppendingPathComponent:fileName];
    
    return path;
}

@end







