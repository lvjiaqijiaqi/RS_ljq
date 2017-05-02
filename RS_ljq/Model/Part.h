//
//  Part.h
//  rs
//
//  Created by lvjiaqi on 16/6/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Part : NSObject
@property(strong,nonatomic) NSString *name; //区名
@property(strong,nonatomic) NSString *pid; //id
@property(strong,nonatomic) NSString *topic; //主题
@property(strong,nonatomic) NSString *topicsNum; //主题数
@property(strong,nonatomic) NSString *lastActive; //
@property(strong,nonatomic) NSString *PartHost;
@property(strong,nonatomic) NSString *img;

@property(strong,nonatomic) NSString *details;

@property(strong,nonatomic) NSString *todayActive;
@property(strong,nonatomic) NSString *ranking;

@property(strong,nonatomic) NSString *rankingTend;
@property(strong,nonatomic) NSString *topicsNumTend;

@property(strong,nonatomic) NSArray *moderators;

-(NSString *)additionStr;
@end
