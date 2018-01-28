//
//  YHProgressHUD.h
//  YHProgressHUD
//
//  Created by 杨应海 on 2018/1/10.
//  Copyright © 2018年 YYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHProgressHUD : UIView

#pragma mark - 删除进度视图
/**
 删除进度视图
 */
+ (void)dismiss;



#pragma mark - 显示提示内容视图
/**
 一个弹出提示内容的视图,仅仅是做个提示,可以交互,并且会自动移除,不需要主动 dismiss
 
 @param text 提示内容
 */
+ (void)show:(NSString *)text;



#pragma mark - 显示一排小方块动画
/**
 显示一排小方块动画, 默认不交互,需要主动 dismiss
 */
+ (void)showRect;

/**
 一般用于网络请求中的提示进度视图 --> 一排小方块动画,默认不交互,需要主动 dismiss
 
 @param text 提示文本内容
 */
+ (void)showRect:(NSString *)text;

/**
 一般用于网络请求中的提示进度视图 --> 一排小方块动画,需要主动 dismiss
 
 @param text 提示文本内容
 @param interaction 是否覆盖整个屏幕
 */
+ (void)showRect:(NSString *)text interaction:(BOOL)interaction;



#pragma mark - 显示一圈小圆点的旋转缩放动画
/**
 一般用于网络请求中的提示进度视图 --> 一圈旋转的圆点动画,默认不交互,需要主动 dismiss
 */
+ (void)showDot;

/**
 一般用于网络请求中的提示进度视图 --> 一圈旋转的圆点动画,默认不交互,需要主动 dismiss
 
 @param text 提示文本内容
 */
+ (void)showDot:(NSString *)text;

/**
 一般用于网络请求中的提示进度视图 --> 一圈旋转的圆点动画,需要主动 dismiss
 
 @param text 提示文本内容
 @param interaction 是否覆盖整个屏幕
 */
+ (void)showDot:(NSString *)text interaction:(BOOL)interaction;

@end
