//
//  WebViewController.h
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXNewsModel.h"
@interface WebViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *mAry;
@property(nonatomic)NSInteger  index;
@property(nonatomic,copy)NSString * aindex;
@property(nonatomic,strong)MXNewsModel *model;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *uid;
@end
