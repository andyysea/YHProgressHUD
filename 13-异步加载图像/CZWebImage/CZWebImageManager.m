//
//  CZWebImageManager.m
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "CZWebImageManager.h"

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


@end
