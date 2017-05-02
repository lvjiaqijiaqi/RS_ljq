//
//  IndexZoneModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexZoneModel : NSObject
@property(nonatomic,assign) NSInteger zid;
@property(nonatomic,strong) NSString *name; //zone名字
@property(nonatomic,strong) NSString *active; //新增加
@property(nonatomic,strong) NSString *topics; //主题数
@property(nonatomic,strong) NSString *topicNum; //帖子总数
@property(nonatomic,strong) NSString *lastActive; //最近活动时间
@property(nonatomic,strong) NSString *img; //图片

-(NSString *)subsiteContent;

@end
