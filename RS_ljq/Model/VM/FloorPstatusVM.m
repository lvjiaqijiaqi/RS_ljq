//
//  FloorPstatusVM.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorPstatusVM.h"

@implementation FloorPstatusVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = VMTypePstatus;
    }
    return self;
}

-(NSString *)body{
    return _body;
}

@end
