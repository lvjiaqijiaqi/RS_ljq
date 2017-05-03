//
//  HomeParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RSparse.h"
@class ProfileModel;

@interface HomeParse : RSparse

@property(nonatomic,strong) ProfileModel *pModel;

-(void)HTMLParseContentOfProfile:(NSString *)content;

@end
