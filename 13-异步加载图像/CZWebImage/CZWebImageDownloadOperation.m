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

/**
 *  自定义操作的入口方法，如果要自定义操作，直接重写此方法
 *  
 *  这个方法在操作添加到队列后 会自动执行
 */
- (void)main {
    @autoreleasepool {
     
        //1. 创建 URL
        NSURL *url = [NSURL URLWithString:_urlString];
        
        //2. 从 URL 获取二进制数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3. 判断二进制数据是否获取成功，将二进制数据转换成图像，并且将图像返回给外部调用方
        if (data != nil) {
            // 获取图像，使用外部属性记录，就可以提供给外部访问了
            UIImage *image = [UIImage imageWithData:data];
            _downloadImage = image;
            
            // 写入沙盒 的是存储的二进制文件
            //4. 将二进制数据保存到沙盒中
            [data writeToFile:_cachaPath atomically:YES];
        }
        
    }
}


@end









