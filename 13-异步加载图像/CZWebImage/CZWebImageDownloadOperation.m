//
//  CZWebImageDownloadOperation.m
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "CZWebImageDownloadOperation.h"

@interface CZWebImageDownloadOperation()

// 下载图像的  url 字符创
@property (nonatomic, copy) NSString *urlString;
// 图像下载之后要存储的路劲
@property (nonatomic, copy) NSString *cachaPath;

@end


@implementation CZWebImageDownloadOperation

+ (instancetype)downloadOperationWithURLString:(NSString *)urlString cachePath:(NSString *)cachePath {
    
    CZWebImageDownloadOperation *op = [[self alloc] init];
    
    // 记录参数
    op.urlString = urlString;
    op.cachaPath = cachePath;
    
    return op;
}

@end






