//
//  MXNewsViewController.h
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MXNewsModel.h"
#import "NewsCell.h"
#import "JHRefresh.h"
@interface MXNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataAry;
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic) NSInteger currentPage;
@property(nonatomic) BOOL isRefreshing;
@property(nonatomic) BOOL isLoadMore;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end
