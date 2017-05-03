//
//  ForumTopicModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "TopicModel.h"

@interface ForumTopicModel : TopicModel


@property(strong,nonatomic) NSString *t_issueTime;
@property(strong,nonatomic) NSString *t_lastReplyTime;
@property(strong,nonatomic) NSString *t_lastReplyUname;

@property(assign,nonatomic) NSInteger *t_Uid;

@property(strong,nonatomic) NSString *t_replyNum;
@property(strong,nonatomic) NSString *t_scanNum;

@property(nonatomic,assign) NSInteger t_maxPage;
@property(nonatomic,assign) NSInteger t_currentPage;

@property(nonatomic,strong) NSString* t_award;
@property(nonatomic,strong) NSString* t_awardDetails;

-(NSString *)subheading;

@end
