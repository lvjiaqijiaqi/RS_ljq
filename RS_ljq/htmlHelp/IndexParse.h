//
//  IndexParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IndexZoneModel;
@class IndexImageModel;
@class IndexUsrRankingModel;
@class IndexTopicRandingModel;

@interface IndexParse : NSObject

@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_new;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_newReply;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_recommend;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_weekHot;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_dayHot;
@property(nonatomic,strong)  NSArray<IndexImageModel *> *topicLis_imgHot;
@property(nonatomic,strong)  NSArray<IndexUsrRankingModel *> *userRankings;
@property(nonatomic,strong)  NSDictionary<NSString *,NSArray<IndexZoneModel*> *> *zoneLists;

-(void)HTMLParseContent:(NSString *)content;

@end
