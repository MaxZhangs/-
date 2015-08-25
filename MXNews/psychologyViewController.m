//
//  psychologyViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "psychologyViewController.h"
#import "WebViewController.h"
#define kpath @"http://news-at.zhihu.com/api/4/theme/13"
#define kReFresh @"http://news-at.zhihu.com/api/4/theme/13/before/"
@interface psychologyViewController ()

@end

@implementation psychologyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"日常心理学";
    self.isRefreshing=NO;
    self.isloadMore=NO;
    self.currentPage=1;
    [self addDataWithUrl:kpath isRefreshing:NO];
    [self createFresh];
    
    // Do any additional setup after loading the view.
}
-(void)createFresh{
    __weak typeof(self)weakSelf=self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing ) {
            return ;
        }
        weakSelf.isRefreshing=YES;
        weakSelf.currentPage=1;
        [weakSelf addDataWithUrl:kpath  isRefreshing:YES];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isloadMore) {
            return ;
        }
        weakSelf.isloadMore=YES;
        weakSelf.currentPage ++;
        NSString *url=[kReFresh stringByAppendingFormat:@"%@",weakSelf.dataUrl.lastObject];
        [weakSelf addDataWithUrl:url isRefreshing:YES];
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MXNewsModel *model=self.dataAry[indexPath.row];
    WebViewController *webView = [[WebViewController alloc]init];
    webView.mAry = [NSMutableArray arrayWithArray:_dataUrl];
    
    webView.aindex =model.uid;
    webView.title=model.title;
    webView.uid=model.uid;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:NO];
    

    
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
