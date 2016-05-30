//
//  CZWebImageDownloadOperation.h
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  负责单个网络图像的下载操作，下载成功，写入沙盒
 */
@interface CZWebImageDownloadOperation : NSOperation

/**
 *  ‘创建’ 一个下载操作，下载 urlString 指定的图像，下载成功后写入 cachePath 目录
 */
+ (instancetype)downloadOperationWithURLString:(NSString *)urlString cachePath:(NSString *)cachePath;

@end
