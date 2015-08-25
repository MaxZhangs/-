//
//  WebViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "WebViewController.h"
#import "DBManager.h"
#import "UMSocial.h"
#define kUrl @"http://daily.zhihu.com/story/"
@interface WebViewController ()
{
    UIWebView *_web;
    NSURLRequest *_request;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBtn:)];
    [barBtn1 setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = barBtn1;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: @"News_Navigation_Share_Highlight"] style:UIBarButtonItemStyleDone target:self action:@selector(shareClick:)];
    [barBtn setTintColor:[UIColor blackColor]];
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: @"News_Navigation_Vote"]style:UIBarButtonItemStyleDone target:self action:@selector(favariteClick:)];
    [barBtn2 setTintColor:[UIColor blackColor]];
    
    self.navigationItem.rightBarButtonItems = @[barBtn2,barBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
   NSString *str = [kUrl stringByAppendingString:self.aindex];
    NSURL *url = [NSURL URLWithString:str];
    
    _request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:_request];
    [self.view addSubview:_web];
    BOOL isExist=[[DBManager sharedManager]isExistModelWithuid:self.model.uid];
    if (isExist) {
        barBtn2.enabled=NO;
    }else{
        barBtn2.enabled=YES;
    }

    // Do any additional setup after loading the view.
}
-(void)favariteClick:(UIBarButtonItem *)item
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"收藏成功" message:@"请点击确定键退出" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 11;
    [alert show];
    item.enabled=NO;
    self.model=[[MXNewsModel alloc]init];
    self.model.title=self.title;
    self.model.uid=self.uid;
    
    [[DBManager sharedManager]insertModel:self.model];
    
    
}

-(void)shareClick:(UIBarButtonItem *)btn
{
    NSString *str = [kUrl stringByAppendingString:self.aindex];
    NSURL *url = [NSURL URLWithString:str];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:urlStr  shareImage:[UIImage imageNamed: @"dropdown_anim__00034"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToEmail,UMShareToWechatTimeline,UMShareToTwitter,UMShareToRenren,UMShareToTencent,UMShareToQzone,nil] delegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)leftBtn:(UIBarButtonItem *)item
{
    //    HeadViewController *head = [[HeadViewController alloc]init];
    [self.navigationController popViewControllerAnimated:NO];
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
