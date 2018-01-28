//
//  YHProgressHUD.m
//  YHProgressHUD
//
//  Created by 杨应海 on 2018/1/10.
//  Copyright © 2018年 YYH. All rights reserved.
//

#import "YHProgressHUD.h"


#define Width_Screen [UIScreen mainScreen].bounds.size.width
#define Height_Screen [UIScreen mainScreen].bounds.size.height
#define IS_IPhoneX  (((Height_Screen == 812) && (Width_Screen == 375)) ? YES : NO)
// 导航条高度 (状态栏 + 导航栏)
#define Height_NavgationBar (IS_IPhoneX ? 88 : 64)


/** 显示的小方块类型 */
typedef NS_ENUM (NSInteger, MyAnimationType) {
    MyAnimationTypeText = 1001,
    MyAnimationTypeRect,
    MyAnimationTypeCicleDot
};


@interface YHProgressHUD ()

/** 当前可视窗口 */
@property (nonatomic, strong) UIWindow *keyWindow;

@end

@implementation YHProgressHUD

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static YHProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark  初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}



#pragma mark - 公共方法
- (void)showText:(NSString *)text Type:(MyAnimationType)Type interaction:(BOOL)interaction {
    
    // 调整背景视图大小
    if (interaction) {
        self.frame = CGRectMake(0, Height_NavgationBar, Width_Screen, Height_Screen - Height_NavgationBar);
    } else {
        self.frame = CGRectMake(0, 0, Width_Screen, Height_Screen);
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_keyWindow addSubview:self];
    
    switch (Type) {
        case MyAnimationTypeRect:
        {
            [self addRectWithText:text interaction:interaction];
        }
            break;
        case MyAnimationTypeCicleDot:
        {
            [self addCircleDotWithText:text interaction:interaction];
        }
            break;
        case MyAnimationTypeText:
        {
            [self showText:text];
        }
            break;
        default:
            break;
    }
}



#pragma mark - 删除进度视图
+ (void)dismiss {
    [[self sharedInstance] remove];
}

- (void)remove {
    if (self.subviews.count) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    }
    [self removeFromSuperview];
}



#pragma mark - 显示提示内容视图
+ (void)show:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:text Type:MyAnimationTypeText interaction:YES];
    });
}

- (void)showText:(NSString *)text {
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    textLabel.text = text;
    textLabel.layer.cornerRadius = 5;
    textLabel.layer.masksToBounds = YES;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    
    NSDictionary *attributesDict = @{NSFontAttributeName : textLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [textLabel.text boundingRectWithSize:CGSizeMake(Width_Screen * 3 / 5, 300) options:options attributes:attributesDict context:NULL];
    textLabel.bounds = CGRectMake(0, 0, labelRect.size.width + 30, labelRect.size.height + 20);
    textLabel.center = CGPointMake(Width_Screen / 2, (Height_Screen - Height_NavgationBar) / 2 - Height_NavgationBar);
    
    // 显示持续时间
    CGFloat duration = text.length * 0.05 + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self remove];
    });
}



#pragma mark - 展示旋转的圆点动画
+ (void)showDot {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:nil Type:MyAnimationTypeCicleDot interaction:NO];
    });
}

+ (void)showDot:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:text Type:MyAnimationTypeCicleDot interaction:NO];
    });
}

+ (void)showDot:(NSString *)text interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:text Type:MyAnimationTypeCicleDot interaction:interaction];
    });
}

#pragma mark  添加选旋转的圆点动画
- (void)addCircleDotWithText:(NSString *)text interaction:(BOOL)interaction {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    CGRect labelRect = CGRectZero;
    CGFloat contentWidth = 100;
    CGFloat contentHeight = 100;
    if (text.length) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        [contentView addSubview:textLabel];
        
        NSDictionary *attributesDict = @{NSFontAttributeName : textLabel.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        labelRect = [textLabel.text boundingRectWithSize:CGSizeMake(Width_Screen * 3 / 5, 300) options:options attributes:attributesDict context:NULL];
        
        labelRect.origin.x = 12;
        labelRect.origin.y = 76;
        contentWidth = labelRect.size.width + 24;
        contentHeight = labelRect.size.height + 90;
        
        if (contentWidth < 100) {
            contentWidth = 100;
            labelRect.origin.x = 0;
            labelRect.size.width = 100;
        }
        
        textLabel.frame = labelRect;
    }
    contentView.bounds = CGRectMake(0, 0, contentWidth, contentHeight);
    if (interaction) {
        contentView.center = CGPointMake(Width_Screen / 2, (Height_Screen - Height_NavgationBar) / 2 - Height_NavgationBar);
    } else {
        contentView.center = CGPointMake(Width_Screen / 2, (Height_Screen - Height_NavgationBar) / 2);
    }
    
    // 由上述可知
    // 如果有提示内容,contentView上面90部分高度用于显示旋转的动画圆点,
    // 如果没有提示内容,宽高都是100,中间显示即可
    NSInteger instanceCount = 10;
    CGFloat   duration = 1.0;
    //创建repelicator对象
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.bounds = CGRectMake(0, 0, 90, 90);
    if (text.length) {
        replicatorLayer.position = CGPointMake(contentWidth / 2, 90 / 2); //y值此处改动画上下位置
    } else {
        replicatorLayer.position = CGPointMake(contentWidth / 2, contentHeight / 2);
    }
    replicatorLayer.instanceCount = instanceCount;
    replicatorLayer.instanceDelay = duration / instanceCount;
    //设置每个实例的变换样式
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
    //    [contentView.layer addSublayer:replicatorLayer]; //此句代码放最后,否则下面的point转换会出现负数
    
    //创建replicatorLayer对象的子图层，replicatorLayer会利用此子图层进行高效复制。并绘制到自身图层上
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(0, 0, 8, 8);
    //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此
    CGPoint point = [replicatorLayer convertPoint:replicatorLayer.position fromLayer:self.layer];
    
    CGFloat offsetY = interaction ? ((point.y - Height_NavgationBar) / 2) : (point.y / 2);
    //    NSLog(@"--> %@\n %f", NSStringFromCGPoint(point),offsetY);
    subLayer.position = CGPointMake(point.x, offsetY ); // y值此处改动画旋转圆圈的大小
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.cornerRadius = 5;
    subLayer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
    //将子图层添加到repelicator上
    [replicatorLayer addSublayer:subLayer];
    
    // subLayer添加动画
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    animaiton.keyPath = @"transform.scale";
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    animaiton.duration = 1.0f;
    animaiton.fillMode = kCAFillModeForwards;
    animaiton.removedOnCompletion = NO;
    animaiton.repeatCount = INT_MAX;
    [subLayer addAnimation:animaiton forKey:@"haha"];
    
    // 词句代码放最后
    [contentView.layer addSublayer:replicatorLayer];
}



#pragma mark - 展示矩形小方块
+ (void)showRect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:nil Type:MyAnimationTypeRect interaction:NO];
    });
}

+ (void)showRect:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:text Type:MyAnimationTypeRect interaction:NO];
    });
}

+ (void)showRect:(NSString *)text interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] showText:text Type:MyAnimationTypeRect interaction:interaction];
    });
}

#pragma mark  添加小矩形
- (void)addRectWithText:(NSString *)text interaction:(BOOL)interaction{
    if (text.length) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((Width_Screen - 300)/ 2, (Height_Screen - Height_NavgationBar) / 2, 300, 40)];
        if (interaction) {
            textLabel.frame = CGRectMake((Width_Screen - 300) / 2, (Height_Screen - Height_NavgationBar) / 2 - Height_NavgationBar, 300, 40);
        }
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:textLabel];
    }
    
    CGFloat rectNum = 6;
    CGFloat width = 4;
    CGFloat height = 50;
    CGFloat margin = 5;
    CGRect rect = CGRectMake((Width_Screen - rectNum * width - (rectNum - 1) * margin) / 2 , (Height_Screen - Height_NavgationBar) / 2 - height, width, height);
    if (interaction) {
        rect = CGRectMake((Width_Screen - rectNum * width - (rectNum - 1) * margin) / 2 , (Height_Screen - Height_NavgationBar) / 2 - Height_NavgationBar - height, width, height);
    }
    for (NSInteger index = 0; index < rectNum; index++) {
        UIView *rectView = [[UIView alloc] initWithFrame:rect];
        rectView.frame = CGRectOffset(rect, index * (width + margin), 0);
        rectView.backgroundColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1.0];
        // 给小方块图层添加动画
        [rectView.layer addAnimation:[self addRectAnimateWithDelay:index * 0.2] forKey:@"hehe"];
        [self addSubview:rectView];
    }
}

#pragma mark 动画
- (CAAnimation*)addRectAnimateWithDelay:(CGFloat)delay {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = YES;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:M_PI];
    animation.duration = 6 * 0.2; //第一个翻转一周，最后一个开始翻转
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

@end
