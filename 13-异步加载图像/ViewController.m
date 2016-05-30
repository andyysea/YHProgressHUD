//
//  ViewController.m
//  13-异步加载图像
//
//  Created by 杨应海 on 16/5/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CZAppInfo.h"
#import "CZAppCell.h"
#import "UIImageView+WebCache.h"

static NSString *cellId = @"cellId";

@interface ViewController () <UITableViewDataSource>

// 表格视图
@property (nonatomic, strong) UITableView *tableView;
// 应用程序列表数组
@property (nonatomic, strong) NSArray <CZAppInfo *> *appList;
// 下载队列
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@end

/**
 *  需求：根视图是 UITableView
 */
@implementation ViewController

- (void)loadView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
//    [_tableView registerClass:[CZAppCell class] forCellReuseIdentifier:cellId];
    [_tableView registerNib:[UINib nibWithNibName:@"CZAppCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 100;
    
    self.view = _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化队列
    _downloadQueue = [[NSOperationQueue alloc] init];
    
    // 异步执行加载数据，方法执行完成之后，不会立即得到结果
    [self loadData];
}

#pragma mark - 加载数据
- (void)loadData {
    
    // 1.获取 http 请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.使用 GET 方法，获取网络数据
    /**
     参数:
     1> URL 字符串 - 必须要有
     2> nil 
     3> 进度 nil
     4> success 网络请求成功的 block 一定有
     5> failure 网络请求失败 block 一定有
     */
    [manager GET:@"https://raw.githubusercontent.com/andyysea/001/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 服务器返回的字典或者数组 （AFN 已经做好了 - 可以直接字典转模型即可）
        NSLog(@"%@  %@",responseObject,[responseObject class]);
        
//        遍历数组字典转模型
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            
            //1> 创建模型
            CZAppInfo *model = [[CZAppInfo alloc] init];
            
            //2> 字典转模型
            [model setValuesForKeysWithDictionary:dict];
            
            //3> 将模型添加到数组
            [arrayM addObject:model];
        }
    //使用属性记录
        self.appList = arrayM;
        
//    重新刷新表格数据
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        NSLog(@"请求失败,%@",error);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appList.count;
}
/**
 问题列表
 1. cell 复用 -> 使用占位图像
 2. 图像重复下载：
 - 图像下载完成，保存在本地
 - 下次再使用的时候，从本地加载
 
 关于`本地`：内存缓存／沙盒缓存
 
 3. 内存缓存的解决办法
 1> 在模型中定义一个属性，有缺陷！内存警告的时候，不好释放在内存中缓存的图像！
 2> 自定义一个`缓存池`
 */
// 解决图像重复下载的问题：
/**
 *  将下载的图像保存在本地： 内存缓存 & 沙盒缓存
 *  内存缓存 ==> 1.在模型中定义一个 图像的模型属性 来记录，
 *              有问题-->- 接收到内存警告不好释放,
 *                      - 只能取消没有完成的下载操作，
 *                      - 但是这时候如果下载操作如果已经都完成了，就解决不了问题了
 *              2.搞一个图像缓冲池  使用字典保存图像  -
 *                - 如果收到内存警告，释放的时候直接清空字典即可
 *  沙盒缓存 --> 保存在磁盘
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CZAppCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // 1>取出模型
    CZAppInfo *model = _appList[indexPath.row];
    
    cell.nameLabel.text = model.name;
    cell.downloadLabel.text = model.download;
    
    // 判断模型数据里面有没有图像，如果有，就设置图像，没有就走下面的下载图像的方法，
    // ==> 下载得到的图像要在合适的位子再保存在数组中，就是使用数组属性记录
//    if (model.image != nil) {
//        
//        NSLog(@"返回模型缓存");
//        
//        cell.iconView.image = model.image;
//        
//        return cell;  // 如果数组中有数据，那么就可以直接使用，并且返回
//    }
    
    
    // 为了设置cell 复用 cell 的图像更新慢的问题， 使用占位符
    UIImage *image = [UIImage imageNamed:@"user_default"];
    cell.iconView.image = image;
    
    // sdwebimage 异步设置图像
    NSURL *url = [NSURL URLWithString:model.icon];
    
    // 根据URL 异步加载图像
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
       
       // 模拟延时  会发现cell 复用的时候 图像更新变化，解决办法，使用占位符
        [NSThread sleepForTimeInterval:2.0];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        // 这里加载完成图像之后，使用模型属性记录，这样就可以保存在数组，下次首先从数组中判断是否有图像
//        model.image = image;
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            cell.iconView.image = image;
        }];
    }];
    
    // 将操作添加到队列中
    [_downloadQueue addOperation:op];
    
    return cell;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

//    1> 释放 根视图 6.0 iOS 6.0 开始默认不在释放视图
//    2> 释放资源
    
    // 如果内存警告，取消没有下载完成的操作,没有执行的操作将从队列中删除
    [_downloadQueue cancelAllOperations];
    
}

@end






