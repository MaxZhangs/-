//
//  BaseViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[[NSMutableArray alloc]init];
    self.dataUrl=[[NSMutableArray alloc]init];
    [self createAFHttpRequest];
    [self createTableView];
    
}

-(void)createAFHttpRequest{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

}
-(void)addDataWithUrl:(NSString *)url isRefreshing:(BOOL)isRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataAry removeAllObjects];
                [weakSelf.dataUrl removeAllObjects];
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *ary = dict[@"stories"];
            for (NSDictionary *dict in ary) {
                MXNewsModel *model = [[MXNewsModel alloc]init];
                model.title = dict[@"title"];
                model.images = dict[@"images"];
                model.uid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                [weakSelf.dataUrl addObject:model.uid];
               
                
                [weakSelf.dataAry addObject:model];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefreshing];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endRefreshing];
    }];
}
-(void)endRefreshing
{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if(self.isloadMore) {
        self.isloadMore = NO;
        [self.tableView footerEndRefreshing];
    }
    
}
-(void)createTableView{
    if (!self.tableView) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
        [self.tableView registerNib :[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MXNewsModel *model=self.dataAry[indexPath.row];
        NewsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
        [cell showDataWithModel:model];
        return cell;
    
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
