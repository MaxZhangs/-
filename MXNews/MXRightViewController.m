//
//  MXRightViewController.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "MXRightViewController.h"
#import "MXNewsViewController.h"
#import "SDImageCache.h"
#import "collectViewController.h"
@interface MXRightViewController ()<UIActionSheetDelegate>

@end

@implementation MXRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[[NSMutableArray alloc]initWithObjects:@"清除缓存", nil];
    
    [self create];
}
-(void)create{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.dataAry[indexPath.row];
    
    return cell;
    
}
-(double)getCachesSize{
    NSUInteger  fileSize=[[SDImageCache sharedImageCache]getSize];
    return fileSize/1024.0/1024.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MXNewsViewController *main=[[MXNewsViewController alloc]init];
    
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"清除缓存:%.4fM",[self getCachesSize]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
            [sheet showInView:main.view];
            
            
        }
            break;
               default:
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
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
