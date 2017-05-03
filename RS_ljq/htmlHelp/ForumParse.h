//
//  ForumParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSparse.h"

@class Floor;
@class ForumTopicModel;
@interface ForumParse : RSparse

@property(strong,nonatomic) NSArray<Floor *>* floors;
@property(strong,nonatomic) ForumTopicModel *topic;

-(void)HTMLParseContent:(NSString *)content;
@end
