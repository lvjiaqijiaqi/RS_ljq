//
//  briefUser.h
//  rs
//
//  Created by lvjiaqi on 16/6/22.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Briefuser : NSObject

@property(strong,nonatomic) NSString *name; //姓名
@property(strong,nonatomic) NSString *grade; //等级
@property(strong,nonatomic) NSString *img; //头像

@property(strong,nonatomic) NSString *money; //金币
@property(strong,nonatomic) NSString *upload; //上传量
@property(strong,nonatomic) NSString *download; //下载量
@property(strong,nonatomic) NSString *torrent; //种子数
@property(strong,nonatomic) NSString *counter; //筹码
@property(strong,nonatomic) NSString *protection; //保种度
@property(strong,nonatomic) NSString *character; //人品

@property(strong,nonatomic) NSString *sex; //性别
@property(strong,nonatomic) NSString *uid; //uid
@property(strong,nonatomic) NSString *topic; //主题数
@property(strong,nonatomic) NSString *postNum; //帖数
@property(strong,nonatomic) NSString *score; //积分

@property(strong,nonatomic) NSString *registerTime; //注册时间
@property(strong,nonatomic) NSString *inlineTime; //在线时间
@property(strong,nonatomic) NSString *lastSignTime; //上次离线时间

@end
