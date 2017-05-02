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
@class Post;
@interface ForumParse : RSparse

@property(strong,nonatomic) NSArray<Floor *>* floors;
@property(strong,nonatomic) Post *post;

-(void)HTMLParseContent:(NSString *)content;
@end
