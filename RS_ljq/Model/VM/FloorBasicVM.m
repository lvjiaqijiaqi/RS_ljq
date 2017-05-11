//
//  FloorBasicVM.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorBasicVM.h"

@implementation FloorBasicVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        _height = 0;
    }
    return self;
}

-(NSString *)body{
    return  @"";
}
-(NSString *)src{
    return @"";
}
-(NSArray<NSDictionary *> *)attachments{
    return [NSArray array];
}

@end
