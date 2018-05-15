//
//  YHProgressHUD.m
//  YHProgressHUD
//
//  Created by YYH on 2018/1/10.
//  Copyright © 2018年 YYH. All rights reserved.
//

#import "YHProgressHUD.h"

//#define kIPhoneX  (((kScreenH == 812) && (kScreenW == 375)) ? YES : NO)

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
// 状态栏高度 -> 当控制器中状态栏隐藏的时候,高度为0
#define KStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define kNavBarH 44
// 顶部导航条高度 (状态栏 + 导航栏)
#define KTopBarH  (KStatusBarH + kNavBarH)
// iPhone X  底部安全域高度
#define KSafeAreaH  ((KStatusBarH > 20) ? 34 : 0)
// 底部标签栏
#define kTabBarH  (KSafeAreaH + 49)
// 比例
/** 不同屏幕缩放比, 主要用于字体,布局等 */
#define kPubScale  (kScreenW / 375)
/** 缩放之后的数值*/
#define kScale(a)  (a * kPubScale)

/** 显示的小方块类型 */
typedef NS_ENUM (NSInteger, MyAnimationType) {
    MyAnimationTypeText = 1001,
    MyAnimationTypeRect,
    MyAnimationTypeCicleDot
};


@interface YHProgressHUD ()

/** 当前可视窗口 */
@property (nonatomic, strong) UIWindow *keyWindow;

/** 新版本下载地址 */
@property (nonatomic, copy) NSString *versionURLStr;

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
        self.frame = CGRectMake(0, KTopBarH, kScreenW, kScreenH - KTopBarH);
    } else {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
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
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [[self sharedInstance] remove];
    //    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
    });
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

#pragma mark  计算显示文字的内容大小和退出时间
- (void)showText:(NSString *)text {
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    textLabel.text = text;
    textLabel.layer.cornerRadius = kScale(5);
    textLabel.layer.masksToBounds = YES;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    textLabel.font = [UIFont systemFontOfSize:kScale(14)];
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    
    NSDictionary *attributesDict = @{NSFontAttributeName : textLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [textLabel.text boundingRectWithSize:CGSizeMake(kScreenW * 3 / 5, 300) options:options attributes:attributesDict context:NULL];
    textLabel.bounds = CGRectMake(0, 0, labelRect.size.width + kScale(30), labelRect.size.height + kScale(20));
    textLabel.center = CGPointMake(kScreenW / 2, (kScreenH - KTopBarH) / 2 - KTopBarH);
    
    // 显示持续时间
    CGFloat duration = text.length * 0.05 + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self remove];
    });
}



#pragma mark - 展示旋转的圆点动画
+ (void)showDot {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:nil Type:MyAnimationTypeCicleDot interaction:NO];
    });
}

+ (void)showDot:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:text Type:MyAnimationTypeCicleDot interaction:NO];
    });
}

+ (void)showDot:(NSString *)text interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:text Type:MyAnimationTypeCicleDot interaction:interaction];
    });
}

#pragma mark  添加选旋转的圆点动画
- (void)addCircleDotWithText:(NSString *)text interaction:(BOOL)interaction {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScale(100), kScale(100))];
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    contentView.layer.cornerRadius = kScale(10);
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    CGRect labelRect = CGRectZero;
    CGFloat contentWidth = kScale(100);
    CGFloat contentHeight = kScale(100);
    if (text.length) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        textLabel.font = [UIFont systemFontOfSize:kScale(13)];
        textLabel.numberOfLines = 0;
        [contentView addSubview:textLabel];
        
        NSDictionary *attributesDict = @{NSFontAttributeName : textLabel.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        labelRect = [textLabel.text boundingRectWithSize:CGSizeMake(kScreenW * 3 / 5, 300) options:options attributes:attributesDict context:NULL];
        
        labelRect.origin.x = kScale(12);
        labelRect.origin.y = kScale(76);
        contentWidth = labelRect.size.width + kScale(24);
        contentHeight = labelRect.size.height + kScale(90);
        
        if (contentWidth < kScale(100)) {
            contentWidth = kScale(100);
            labelRect.origin.x = 0;
            labelRect.size.width = kScale(100);
        }
        
        textLabel.frame = labelRect;
    }
    contentView.bounds = CGRectMake(0, 0, contentWidth, contentHeight);
    if (interaction) {
        contentView.center = CGPointMake(kScreenW / 2, (kScreenH - KTopBarH) / 2 - KTopBarH);
    } else {
        contentView.center = CGPointMake(kScreenW / 2, (kScreenH - KTopBarH) / 2);
    }
    
    // 由上述可知
    // 如果有提示内容,contentView上面90部分高度用于显示旋转的动画圆点,
    // 如果没有提示内容,宽高都是100,中间显示即可
    NSInteger instanceCount = 10;
    CGFloat   duration = 1.0;
    //创建repelicator对象
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.bounds = CGRectMake(0, 0, kScale(90), kScale(90));
    if (text.length) {
        replicatorLayer.position = CGPointMake(contentWidth / 2, kScale(90) / 2); //y值此处改动画上下位置
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
    subLayer.frame = CGRectMake(0, 0, kScale(8), kScale(8));
    //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此
    CGPoint point = [replicatorLayer convertPoint:replicatorLayer.position fromLayer:self.layer];
    
    CGFloat offsetY = interaction ? ((point.y - KTopBarH) / 2) : (point.y / 2);
    //    NSLog(@"--> %@\n %f", NSStringFromCGPoint(point),offsetY);
    subLayer.position = CGPointMake(point.x, offsetY ); // y值此处改动画旋转圆圈的大小
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.cornerRadius = kScale(5);
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
        [[self sharedInstance] remove];;
        [[self sharedInstance] showText:nil Type:MyAnimationTypeRect interaction:NO];
    });
}

+ (void)showRect:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:text Type:MyAnimationTypeRect interaction:NO];
    });
}

+ (void)showRect:(NSString *)text interaction:(BOOL)interaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showText:text Type:MyAnimationTypeRect interaction:interaction];
    });
}

#pragma mark  添加小矩形
- (void)addRectWithText:(NSString *)text interaction:(BOOL)interaction{
    if (text.length) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - kScale(300))/ 2, (kScreenH - KTopBarH) / 2, kScale(300), kScale(40))];
        if (interaction) {
            textLabel.frame = CGRectMake((kScreenW - kScale(300)) / 2, (kScreenH - KTopBarH) / 2 - KTopBarH, kScale(300), kScale(40));
        }
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:kScale(13)];
        [self addSubview:textLabel];
    }
    
    CGFloat rectNum = 6;
    CGFloat width = kScale(4);
    CGFloat height = kScale(50);
    CGFloat margin = kScale(5);
    CGRect rect = CGRectMake((kScreenW - rectNum * width - (rectNum - 1) * margin) / 2 , (kScreenH - KTopBarH) / 2 - height, width, height);
    if (interaction) {
        rect = CGRectMake((kScreenW - rectNum * width - (rectNum - 1) * margin) / 2 , (kScreenH - KTopBarH) / 2 - KTopBarH - height, width, height);
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



#pragma mark - 系统弹出的提示方法
#pragma mark  只弹出Message
+ (void)showAlertMessage:(NSString *)message {
    // 先dismiss,避免冲突
    [self dismiss];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:sureAction];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessage addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, message.length)];
    [alertC setValue:alertMessage forKey:@"_attributedMessage"];
    // 修改功能按钮颜色按钮的代码在 iOS 8.0.2 附近的版本会奔溃
    //    [sureAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

+ (void)showAlertMessage:(NSString *)message complete:(void (^)(void))complete {
    // 先dismiss,避免冲突
    [self dismiss];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessage addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, message.length)];
    [alertC setValue:alertMessage forKey:@"_attributedMessage"];
    
    //    [sureAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark  有Title和Message
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message {
    // 先dismiss,避免冲突
    [self dismiss];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:sureAction];
    
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [alertTitle addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName :[UIColor blackColor]} range:NSMakeRange(0, title.length)];
    [alertC setValue:alertTitle forKey:@"_attributedTitle"];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessage addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(0, message.length)];
    [alertC setValue:alertMessage forKey:@"_attributedMessage"];
    
    //    [sureAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message complete:(void (^)(void))complete {
    // 先dismiss,避免冲突
    [self dismiss];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [alertTitle addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName :[UIColor blackColor]} range:NSMakeRange(0, title.length)];
    [alertC setValue:alertTitle forKey:@"_attributedTitle"];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessage addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(0, message.length)];
    [alertC setValue:alertMessage forKey:@"_attributedMessage"];
    
    //    [cancelAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    //    [sureAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - 移动清收专用版本更新提示视图
/**
 弹出新版本更新信息提示界面,并强制更新,点击确定按钮提示更新
 
 @param versionInfo 新版本更新信息
 @param urlstr 更新地址
 */
+ (void)showNewVersionInfo:(NSString *)versionInfo downURLStr:(NSString *)urlstr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showVersionInfo:versionInfo downURLStr:urlstr];
    });
}

- (void)showVersionInfo:(NSString *)versionInfo downURLStr:(NSString *)urlStr {
    
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1.0];
    [_keyWindow addSubview:self];
    
    CGFloat width = kScale(280);
    CGFloat height = width * 1.2;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = self.center;
    contentView.layer.cornerRadius = kScale(10);
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScale(5), width, kScale(35))];
    titleLabel.text = @"新版本更新内容";
    titleLabel.font = [UIFont boldSystemFontOfSize:kScale(19)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kScale(10), kScale(50), width - 2 * kScale(10), height - kScale(50) - kScale(60))];
    textView.text = versionInfo;
    textView.editable = NO;
    textView.selectable = NO;
    textView.font = [UIFont systemFontOfSize:kScale(17)];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [contentView addSubview:textView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScale(10), height - kScale(60), width - 2 * kScale(10), kScale(44))];
    button.titleLabel.font = [UIFont systemFontOfSize:24];
    [button setTitle:@"立刻更新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:48 / 255.0 blue:48 / 255.0 alpha:1.0];
    button.layer.cornerRadius = kScale(5);
    button.layer.masksToBounds = YES;
    [contentView addSubview:button];
    
    [button addTarget:self action:@selector(updateVersionClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 记录下载地址
    _versionURLStr = urlStr;
}

#pragma mark  版本更新点击方法
- (void)updateVersionClick {
    NSURL *url = [NSURL URLWithString:self.versionURLStr];
    if (@available(iOS 10, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.4f animations:^{
        window.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        exit(0);
    }];
}




#pragma mark - 移动清收专用网络加载提示
/**
 移动清收'专用'网络加载提示,有公司的logo动画
 
 @param text 提示文字
 */
+ (void)showHTLoading:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedInstance] remove];
        [[self sharedInstance] showTHLoadingWithText:text];
    });
}

- (void)showTHLoadingWithText:(NSString *)text {
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    [_keyWindow addSubview:self];
    
    // 数据
    NSMutableArray *arrayM = [NSMutableArray array];
    NSInteger count = 6;
    for (NSInteger i = 0; i < count; i++) {
        NSString *imageName = [@"animation_three_" stringByAppendingFormat:@"%02zd.png", i + 1];
        // 直接用不会释放内存 -> 初次调用会保存在内存中,下次再查找该图片的时候会直接从内存中找, 即便渲染视图释放了也不会释放图片资源
        //        UIImage *image = [UIImage imageNamed:imageName];
        // 路劲加载的方式,图片渲染视图释放之后,图片资源也会被释放
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            [arrayM addObject:image];
        }
    }
    NSTimeInterval duration = count / 3;
    UIImage *animatedImage = [UIImage animatedImageWithImages:arrayM duration:duration];
    
    UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - kScale(68.75)) / 2, kScreenH / 2 - kScale(88.5), kScale(68.75), kScale(88.5))];
    [self addSubview:pictureImageView];
    pictureImageView.image = animatedImage;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - kScale(200)) / 2, kScreenH / 2 - kScale(10), kScale(200), kScale(20))];
    if (text.length) {
        titleLabel.text = text;
    } else {
        titleLabel.text = @"数据加载中...";
    }
    titleLabel.font = [UIFont systemFontOfSize:kScale(13)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.textColor = [UIColor colorFromHexCode:@"#6B6B6B"];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
}

@end
