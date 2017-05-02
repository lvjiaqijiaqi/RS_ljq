//
//  ZoneParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSparse.h"

@class Part;
@class Post;

@interface ZoneParse : RSparse

@property(nonatomic,strong) Part *headPart;
@property(nonatomic,strong) NSArray<Post *> *PostList;

-(void)HTMLParseContent:(NSString *)content;

@end
