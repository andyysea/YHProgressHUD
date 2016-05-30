//
//  CZAppInfo.h
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIKit/UIkit.h"

@interface CZAppInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *icon;

// 图像，模型属性保存数据，不好释放根视图
//@property (nonatomic, strong) UIImage *image;

@end
