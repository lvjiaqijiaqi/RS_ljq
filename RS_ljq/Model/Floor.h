//
//  Floor.h
//  rs
//
//  Created by lvjiaqi on 16/6/22.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BriefUser.h"
@class Comment;

@interface Floor : NSObject

@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *userId;
@property(strong,nonatomic) NSString *floorNum;
@property(strong,nonatomic) NSString *status;

@property(strong,nonatomic) NSString *quote;
@property(strong,nonatomic) NSString *pstatus;

@property(strong,nonatomic) Briefuser *user;

@property(nonatomic) int isHoster;

@property(strong,nonatomic) NSString *body;
@property(strong,nonatomic) NSArray *imgs;

@property(strong,nonatomic) NSArray<Comment *> *comments;
@property(strong,nonatomic) NSMutableArray *rates;

-(void)setAttributeBody:(NSString *)content;

@end
