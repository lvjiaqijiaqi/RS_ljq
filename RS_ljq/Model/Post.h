//
//  Post.h
//  rs
//
//  Created by lvjiaqi on 16/6/22.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IndexTopicRandingModel;

@interface Post : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *userName;

@property(strong,nonatomic) NSString *issueTime;
@property(strong,nonatomic) NSString *lastReplyTime;
@property(strong,nonatomic) NSString *lastReplyUname;

@property(assign,nonatomic) NSInteger pid;
@property(assign,nonatomic) NSInteger *uid;

@property(strong,nonatomic) NSString *reply;
@property(strong,nonatomic) NSString *scan;

@property(nonatomic,assign) NSInteger maxPage;
@property(nonatomic,assign) NSInteger currentPage;

@property(nonatomic,strong) NSString* award;
@property(nonatomic,strong) NSString* awardDetails;

-(NSString *)addition_publish;
-(void)updateModel:(Post *)model;
-(void)initMiniPost:(IndexTopicRandingModel *)model;
@end
