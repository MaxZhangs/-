//
//  MXNewsViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "MXNewsViewController.h"
#import "SDImageCache.h"
#import "WebViewController.h"
#import "MXRightViewController.h"
#define  kCellId @"NewsCell"
#define  kUrl @"http://news-at.zhihu.com/api/4/stories/"
@interface MXNewsViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *urlData;
    NSMutableArray *data;
    NSMutableArray *dataUrl;
    NSMutableArray *dataTop;
    NSInteger _count ;
    NSString *timeString;
    NSTimer *_timer;
    NSInteger a;
    UIScrollView *_scrollerView;
    UIPageControl *_pageControl;
}
@property (nonatomic )NSInteger count;
@end

@implementation MXNewsViewController
-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"首页";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
    NSDateFormatter *date=[[NSDateFormatter alloc]init];
    date.dateFormat=@"yyyyMMdd";
    timeString=[date stringFromDate:[NSDate date]];
    self.count=timeString.integerValue;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.isRefreshing=NO;
    self.isLoadMore=NO;
    self.currentPage=0;
    [self createRequest];
    [self createTableView];
    
    [self loadWithDate
     ];
    [self createTimer];
    [self createRefreshing];

    
    // Do any additional setup after loading the view.
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}
-(double)getCachesSize{
    NSUInteger  fileSize=[[SDImageCache sharedImageCache]getSize];
    return fileSize/1024.0/1024.0;
}

-(void)onClick:(UIBarButtonItem *)btn{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"清除缓存会造成重新加载图片,\n是否清除？\n缓存:%.4fM",[self getCachesSize]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];


    //[self.navigationItem.leftBarButtonItem setEnabled:NO];
//    MXRightViewController *right=[[MXRightViewController alloc]init];
//    right.tableView.backgroundColor=[UIColor clearColor];
//    right.modalPresentationStyle=UIModalPresentationPopover;
//    right.preferredContentSize=CGSizeMake(120, 40);
//    UIPopoverPresentationController *popVC = right.popoverPresentationController;
//    //从item 弹出
//    popVC.barButtonItem = btn;
//    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    
//    popVC.delegate = self;
//    [self.view.window.rootViewController presentViewController:right animated:YES completion:nil];

    
}
-(void)createRequest
{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArr = [[NSMutableArray alloc]init];
    urlData = [[NSMutableArray alloc]init];
    data = [[NSMutableArray alloc]init];
    dataUrl = [[NSMutableArray alloc]init];
    dataTop = [[NSMutableArray alloc]init];
}

-(void)createRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        [weakSelf loadWithDate];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage ++;
        
        weakSelf.count--;
        
        if (weakSelf.count%100==0) {
            weakSelf.count = (weakSelf.count/100-1)*100+29;
        }
        NSString *url = [kUrl stringByAppendingFormat:@"before/%ld",weakSelf.count];
       // NSLog(@"%@",url);
        [weakSelf loadWithData1WithUrl:url];
    }];

}

-(void)endReFreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }

}
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
}
-(void)loadWithData1WithUrl:(NSString *)url;
{
    
    
    __weak typeof(self)weakSelf = self;
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects];
                [dataUrl removeAllObjects];
            }
            NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            NSArray *topArr = dict1[@"top_stories"];
            for (NSDictionary *topdict in topArr) {
                [urlData addObject:topdict[@"image"]];
                [data addObject:topdict[@"title"]];
            }
            NSArray *ary = dict1[@"stories"];
            for (NSDictionary *dict in ary) {
                MXNewsModel *model = [[MXNewsModel alloc]init];
                model.title = dict[@"title"];
                model.images = dict[@"images"];
                model.uid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                [dataUrl addObject:model.uid];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
           
        }
        [weakSelf endReFreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endReFreshing];
        
    }];
    
    
}
-(void)loadWithDate{
    NSString *url = [kUrl stringByAppendingString:@"latest"];
   // NSLog(@"%@",url);
    __weak typeof(self)weakSelf = self;
   
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.currentPage == 0) {
                [weakSelf.dataArr removeAllObjects];
                [dataUrl removeAllObjects];
                [dataTop removeAllObjects];
            }
            NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            NSArray *topArr = dict1[@"top_stories"];
            for (NSDictionary *topdict in topArr) {
                [urlData addObject:topdict[@"image"]];
                [data addObject:topdict[@"title"]];
                [dataTop addObject:[NSString stringWithFormat:@"%@",topdict[@"id"]]];
                
            }
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
            
            _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 140, 80, 30)];
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
            _pageControl.numberOfPages = dataTop.count;
            _pageControl.tag = 101;
            
            _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
            _scrollerView.tag = 11;
            //_scrollerView的内容大小
            _scrollerView.contentSize = CGSizeMake(topArr.count*_scrollerView.bounds.size.width, 0);
            
            //给scrollView添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
            [_scrollerView addGestureRecognizer:tap];
            
            //MXNewsModel *model = [[MXNewsModel alloc]init];
            a = topArr.count;
           // NSLog(@"aaaa%ld",a);
            for (int i = 0; i<topArr.count; i++)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*_scrollerView.bounds.size.width, 170,_scrollerView.bounds.size.width, 30)];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollerView.bounds.size.width, 0, _scrollerView.bounds.size.width, 200)];
                
                if (i!=topArr.count) {
                    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlData[i]]]]];
                    imageView.image = image;
                }else{
                    
                    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlData[0]]]]];
                    imageView.image = image;
                    
                }
                
                label.text = data[i];
                label.font = [UIFont systemFontOfSize:14];
                label.adjustsFontSizeToFitWidth = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor grayColor];
              //  NSLog(@"%@",model.image);
                _scrollerView.pagingEnabled = YES;
                _scrollerView.delegate = self;
                [_scrollerView addSubview:imageView];
                [_scrollerView addSubview:label];
                
            }
            [view addSubview:_scrollerView];
            [view addSubview:_pageControl];
            weakSelf.tableView.tableHeaderView = view;
            
           
            
            NSArray *ary = dict1[@"stories"];
            for (NSDictionary *dict in ary) {
                MXNewsModel *model = [[MXNewsModel alloc]init];
                model.title = dict[@"title"];
                model.images = dict[@"images"];
                model.uid = [NSString stringWithFormat:@"%@",dict[@"id"]];
                [dataUrl addObject:model.uid];
             
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endReFreshing];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endReFreshing];
        
    }];
    
    

}
-(void)onTap:(UITapGestureRecognizer *)sender
{
    WebViewController *webView = [[WebViewController alloc]init];
    webView.mAry = [NSMutableArray arrayWithArray:dataTop];
    webView.title=data[_pageControl.currentPage];
    webView.uid=dataTop[_pageControl.currentPage];
    webView.model=[[MXNewsModel alloc]init];
       
    webView.aindex =dataTop[_pageControl.currentPage];
    
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:NO];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    MXNewsModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXNewsModel *model=self.dataArr[indexPath.row];
    WebViewController *webView = [[WebViewController alloc]init];
    webView.mAry = [NSMutableArray arrayWithArray:dataUrl];
    webView.aindex =model.uid;
    webView.title=model.title;
    webView.uid=model.uid;
    //NSLog(@"%@",webView.title);
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:NO];
    
}

-(void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
}
-(void)run
{
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:11];
    
    sv.contentOffset = CGPointMake(sv.contentOffset.x +sv.contentSize.width/a, 0)  ;
    
    _pageControl.currentPage +=1;
    if (sv.contentOffset.x == sv.bounds.size
        .width*a)
    {
        [sv setContentOffset:CGPointMake(0, 0)];
        _pageControl.currentPage = 0;
    }
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x == _scrollerView.bounds.size
        .width*a)
    {
        
        [_scrollerView setContentOffset:CGPointMake(0, 0)];
    }
    _pageControl.currentPage = _scrollerView.contentOffset.x/_scrollerView.frame.size.width;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
