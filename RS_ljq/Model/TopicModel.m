//
//  TopicModel.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.t_Id = 0;
        self.t_Cat = 0;
        self.t_Name = @"";
        self.t_Addition = @"";
        self.t_userName = @"";
         
    }
    return self;
}

@end
