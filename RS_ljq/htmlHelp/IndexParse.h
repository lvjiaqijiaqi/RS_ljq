//
//  IndexParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TopicModel;
@class IndexUsrRankingModel;
@class CornerModel;

@interface IndexParse : NSObject

@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_new;
@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_newReply;
@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_recommend;
@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_weekHot;
@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_dayHot;
@property(nonatomic,strong)  NSArray<TopicModel *> *topicLis_imgHot;

@property(nonatomic,strong)  NSArray<IndexUsrRankingModel *> *userRankings;
@property(nonatomic,strong)  NSDictionary<NSString *,NSArray<CornerModel*> *> *zoneLists;

-(void)HTMLParseContent:(NSString *)content;

@end
