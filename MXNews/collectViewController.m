//
//  collectViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/6.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "collectViewController.h"
#import "MXNewsModel.h"
#import "DBManager.h"
#import "WebViewController.h"

@interface collectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataAry;

}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataAry;

@end

@implementation collectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self];
    
    self.title=@"我的收藏";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
    [self createTableView];
    // Do any additional setup after loading the view.
}
-(void)onClick:(UIBarButtonItem *)item{
    if (self.tableView.editing==NO) {
        [self.tableView setEditing:YES animated:YES];
        item.title=@"完成";
    }else{
        [self.tableView setEditing:NO animated:YES];
        item.title=@"删除";
    }

}
-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    [self.view addSubview:self.tableView];
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    
    self.tableView.tableFooterView=view;

    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    NSArray *ary=[[DBManager sharedManager] fetchAllData];
    //NSLog(@"%@",ary);
    self.dataAry=[[NSMutableArray alloc]init];
    [self.dataAry addObjectsFromArray:ary];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *web=[[WebViewController alloc]init];
    MXNewsModel *model=self.dataAry[indexPath.row];
    web.model=model;
    web.aindex =model.uid;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:web animated:YES];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    MXNewsModel *model=self.dataAry[indexPath.row];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.textLabel.text=model.title;
    
    return cell;
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    MXNewsModel *model=self.dataAry[indexPath.row];
//    cell.textLabel.text=model.title;
//    return cell;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MXNewsModel *model=self.dataAry[indexPath.row];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
       // NSLog(@"00:%@",model.uid);
        [[DBManager sharedManager]deleteModelWithuid:model.uid];
        
        
        [self.dataAry removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    }
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
