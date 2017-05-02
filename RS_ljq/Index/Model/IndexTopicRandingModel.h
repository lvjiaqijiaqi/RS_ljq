//
//  indexTopicRandingModel.h
//  RsByLjq
//
//  Created by lvjiaqi on 2016/12/4.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, topicCat) {
    RS_topicNew = 0,
    RS_topicLastReply,
    RS_topicRecomend,
    RS_topicDayHot,
    RS_topicWeekHot,
};

@interface IndexTopicRandingModel : NSObject

@property(nonatomic,strong) NSString *topicName;
@property(nonatomic,assign) NSInteger topicId;
@property(nonatomic,assign) topicCat topicCategory;
@property(nonatomic,strong) NSString *topicAddition;
@property(nonatomic,strong) NSString *topicUser;

@end
