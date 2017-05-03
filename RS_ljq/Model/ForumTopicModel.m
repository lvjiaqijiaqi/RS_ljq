//
//  ForumTopicModel.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "ForumTopicModel.h"

@implementation ForumTopicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _t_Uid = 0;
    }
    return self;
}

-(NSString *)subheading{
    
    return [[NSString alloc] initWithFormat:@"%@ %@",self.t_userName,self.t_issueTime];
    
}

@end
