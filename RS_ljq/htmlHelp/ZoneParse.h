//
//  ZoneParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSparse.h"

@class CornerDetailModel;
@class ForumTopicModel;

@interface ZoneParse : RSparse

@property(nonatomic,strong) CornerDetailModel *corner;
@property(nonatomic,strong) NSArray<ForumTopicModel *> *topicList;

-(void)HTMLParseContent:(NSString *)content;

@end
