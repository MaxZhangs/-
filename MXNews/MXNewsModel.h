//
//  MXNewsModel.h
//  MXNews
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXNewsModel : NSObject
@property(nonatomic,strong)NSArray *images;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *uid;
@end
/*
 {
 "date": "20150803",
 "stories": [
 {
 "images": [
 "http://pic3.zhimg.com/67ecab8cfb5935e080fdc749d48a35b6.jpg"
 ],
 "type": 0,
 "id": 7030736,
 "ga_prefix": "080319",
 "title": "今晚的修破斯哒是 · 陈坤"
 },
*/