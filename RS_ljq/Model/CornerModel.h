//
//  Corner.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Corner : NSObject

@property(nonatomic,assign) NSInteger c_Id;
@property(nonatomic,strong) NSString *c_Name; //zone名字
@property(nonatomic,strong) NSString *c_Active; //新增加
@property(nonatomic,strong) NSString *c_TopicNum; //主题数
@property(nonatomic,strong) NSString *c_PostNum; //帖子总数
@property(nonatomic,strong) NSString *c_LastActive; //最近活动时间
@property(nonatomic,strong) NSString *c_Img; //图片

-(NSString *)subsiteContent;

@end
