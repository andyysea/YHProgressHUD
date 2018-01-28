//
//  ViewController.m
//  YHProgressHUD
//
//  Created by 杨应海 on 2018/1/10.
//  Copyright © 2018年 YYH. All rights reserved.
//

#import "ViewController.h"
#import "YHProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - 按钮点击方法
- (void)buttonClick:(UIButton *)button {
    
//            [YHProgressHUD showRect];
//         [YHProgressHUD showRect:@"努力加载中,请稍后..."];
    //    [YHProgressHUD showRect:@"测试" interaction:YES];
    
//        [YHProgressHUD showDot:@"努努力加载努力加载努力加载努力加载努力加载努力加载努力加载努力加载努力加载努力加载请稍后..." interaction:YES];
    //    [YHProgressHUD showDot];
        [YHProgressHUD showDot:@"努力加载中,请稍后..."];
    
//    [YHProgressHUD show:@"努力加载力,请稍载力后..\n努力加载中,请稍后...努力加载中,请稍后...."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [YHProgressHUD dismiss];
        [YHProgressHUD show:@"测试一下啊/////"];
    });
}






@end
