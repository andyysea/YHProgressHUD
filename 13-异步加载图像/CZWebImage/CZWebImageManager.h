//
//  CZWebImageManager.h
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  新建图像视图管理器，负责所有的图像的下载和缓存，以及取消，是一个单例
 */
@interface CZWebImageManager : NSObject

// 全局访问点，单例
+ (instancetype)sharedManger;

// 使用 urlString 下载图像， 通过 block 回调下载的图像
- (void)downloadImageWithURLString:(NSString *)urlString completion:(void(^)(UIImage *))completion;
@end
