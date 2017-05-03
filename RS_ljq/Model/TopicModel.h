//
//  TopicModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TopicCat) {
    RS_topicNew = 0,
    RS_topicLastReply,
    RS_topicRecomend,
    RS_topicDayHot,
    RS_topicWeekHot,
    RS_topicHotImg
};

@interface TopicModel : NSObject

@property(nonatomic,strong) NSString *t_Name;
@property(nonatomic,assign) NSInteger t_Id;
@property(nonatomic,assign) TopicCat t_Cat;

@property(nonatomic,strong) NSString *t_userName;
@property(nonatomic,strong) NSString *t_Addition;

@property(nonatomic,strong) NSString *t_Img;
@end
