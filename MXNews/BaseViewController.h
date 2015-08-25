//
//  BaseViewController.h
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "NewsCell.h"
#import "MXNewsModel.h"
@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataAry;
    NSMutableArray *_dataUrl;
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isloadMore;
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataAry;
@property(nonatomic,strong)NSMutableArray *dataUrl;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isloadMore;
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
-(void)addDataWithUrl:(NSString *)url isRefreshing:(BOOL)isRefreshing;
-(void)endRefreshing;
@end
