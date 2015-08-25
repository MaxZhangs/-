//
//  MXLeftViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "MXLeftViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "MXNewsViewController.h"
#import "psychologyViewController.h"
#import "dsignViewController.h"
#import "economyViewController.h"
#import "movieViewController.h"
#import "musicViewController.h"
#import "animationViewController.h"
#import "sportViewController.h"
#import "collectViewController.h"
@interface MXLeftViewController
()

@end

@implementation MXLeftViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}
 

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width-120,  self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    
    self.tableView.tableFooterView=view;
    self.dataAry=[[NSMutableArray alloc]initWithObjects:@"首页",@"日常心理学",@"设计日报",@"财经日报",@"电影日报",@"音乐日报",@"动漫日报",@"体育日报",@"我的收藏", nil];
 
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
    static NSString *str=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.dataAry[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:21];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    switch (indexPath.row) {
        case 0:
        {
            MXNewsViewController *main=[[MXNewsViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:main];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 1:
        {
            psychologyViewController *psy=[[psychologyViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:psy];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 2:
        {
            dsignViewController *ds=[[dsignViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:ds];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 3:
        {
            economyViewController *eco=[[economyViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:eco];
            [menuController setRootController:nav animated:YES];
        }
            break; 
        case 4:
        {
            movieViewController *movie=[[movieViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:movie];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 5:
        {
            musicViewController *mu=[[musicViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mu];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 6:
        {
            animationViewController *ani=[[animationViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:ani];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 7:
        {
            sportViewController *spo=[[sportViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:spo];
            [menuController setRootController:nav animated:YES];
        }
            break;
        case 8:{
            collectViewController *collect=[[collectViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:collect];
            [menuController setRootController:nav animated:YES];

        }
            break;
        default:
            break;
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
