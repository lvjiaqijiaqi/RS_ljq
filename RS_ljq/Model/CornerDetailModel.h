//
//  CornerDetailModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "CornerModel.h"

@interface CornerDetailModel : CornerModel


@property(strong,nonatomic) NSString *c_PartHost;
@property(strong,nonatomic) NSString *c_HeaderImg; //板块主页图片
@property(strong,nonatomic) NSString *c_Details; //简介
@property(strong,nonatomic) NSString *c_TodayActive; //日活
@property(strong,nonatomic) NSString *c_Ranking; //排名
@property(strong,nonatomic) NSString *c_RankingTend;
@property(strong,nonatomic) NSString *c_TopicsNumTend; //趋势
@property(strong,nonatomic) NSArray *c_Moderators; //版主

-(NSString *)moderatorsAddition;
@end
