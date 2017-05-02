//
//  Post.m
//  rs
//
//  Created by lvjiaqi on 16/6/22.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "Post.h"
#import "IndexTopicRandingModel.h"

@implementation Post

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxPage = 0;
        _currentPage = 0;
    }
    return self;
}

-(NSString *)addition_newReply{
    return [NSString stringWithFormat:@"%@  %@",self.lastReplyUname,self.lastReplyTime];
}
-(NSString *)addition_publish{
    return [NSString stringWithFormat:@"%@  %@",self.userName,self.issueTime];
}

-(void)updateModel:(Post *)model{
    if (model) {
        (model.award != nil) && (self.award = model.award);
        (model.scan != nil) && (self.scan = model.scan);
        (model.maxPage != 0) && (self.maxPage = model.maxPage);
        (model.currentPage != 0) && (self.currentPage = model.currentPage);
        (model.reply != nil) && (self.reply = model.reply);
    }
}

/*
@property(nonatomic,strong) NSString *topicName;
@property(nonatomic,assign) NSInteger topicId;
@property(nonatomic,assign) topicCat topicCategory;
@property(nonatomic,strong) NSString *topicAddition;
@property(nonatomic,strong) NSString *topicUser;
*/
-(void)initMiniPost:(IndexTopicRandingModel *)model{
    self.pid = model.topicId;
    self.name = model.topicName;
}
@end
