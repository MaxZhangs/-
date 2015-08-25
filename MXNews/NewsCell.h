//
//  NewsCell.h
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXNewsModel.h"
@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
-(void)showDataWithModel:(MXNewsModel *)model;
@end
