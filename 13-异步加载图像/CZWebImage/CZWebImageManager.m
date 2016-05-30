//
//  CZWebImageManager.m
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "CZWebImageManager.h"

@implementation CZWebImageManager

+ (instancetype)sharedManger {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
