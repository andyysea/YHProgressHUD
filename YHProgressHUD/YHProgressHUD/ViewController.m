//
//  ViewController.m
//  YHProgressHUD
//
//  Created by YYH on 2018/1/10.
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
    
//    self.navigationController.navigationBarHidden = YES;
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark - 按钮点击方法
- (void)buttonClick:(UIButton *)button {
    
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSLog(@"-->%f", height);
    
//    [YHProgressHUD show:@"测试一下啊啊啊啊 ...."];
//    [YHProgressHUD showDot];
//    [YHProgressHUD showDot:@"测试啊"];
//    [YHProgressHUD showDot:@"说了是测试一下..." interaction:YES];
//
//    [YHProgressHUD showRect];
//    [YHProgressHUD showRect:@"就是测试怎么了"];
//    [YHProgressHUD showRect:@"呵呵呵呵呵呵...." interaction:YES];
//
    [YHProgressHUD showHTLoading:@"努力加载中!"];
}






@end
