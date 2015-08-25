//
//  NewsCell.m
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(MXNewsModel *)model{
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed: @"Account_Avatar"]];
    self.HeadImage.layer.masksToBounds = YES;
    self.HeadImage.layer.cornerRadius = 8;
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Action_Button_Red.png"]];

    self.title.text=model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
