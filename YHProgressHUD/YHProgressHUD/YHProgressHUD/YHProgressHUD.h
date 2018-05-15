//
//  YHProgressHUD.h
//  YHProgressHUD
//
//  Created by YYH on 2018/1/10.
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
 一个弹出提示内容的视图, --> 仅仅是做个提示,可以交互,并且会自动移除,不需要主动 dismiss
 
 @param text 提示内容
 */
+ (void)show:(NSString *)text;




#pragma mark - 显示一排小方块动画
/**
 显示一排小方块动画, --> 默认不交互,需要主动 dismiss
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




#pragma mark - 系统弹出的提示方法
#pragma mark   只弹出Message
/**
 弹出一个系统的AlertController提示, --> 只有提示内容,并且用大字体显示,无回调
 
 @param message 提示内容
 */
+ (void)showAlertMessage:(NSString *)message;

/**
 弹出一个系统的AlertController提示, --> 只有提示内容,并且用大字体显示,有回调
 
 @param message 提示内容
 @param complete 点击确定按钮的时候执行Block
 */
+ (void)showAlertMessage:(NSString *)message complete:(void(^)(void))complete;




#pragma mark  有Title和Message
/**
 弹出一个系统的AlertController提示, --> 有标题有内容,正常字体显示,无回调
 
 @param title 提示标题
 @param message 提示内容
 */
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message;

/**
 弹出一个系统的AlertController提示, --> 有标题有内容,正常字体显示,有回调
 
 @param title 提示标题
 @param message 提示内容
 @param complete 点击确定按钮的时候执行回调
 */
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message complete:(void(^)(void))complete;




#pragma mark - 移动清收专用版本更新提示视图
/**
 弹出新版本更新信息提示界面,并强制更新,点击确定按钮提示更新
 
 @param versionInfo 新版本更新信息
 @param urlstr 更新地址
 */
+ (void)showNewVersionInfo:(NSString *)versionInfo downURLStr:(NSString *)urlstr;



#pragma mark - 移动清收专用网络加载提示

/**
 移动清收'专用'网络加载提示,有公司的logo动画
 
 @param text 提示文字
 */
+ (void)showHTLoading:(NSString *)text;


@end
