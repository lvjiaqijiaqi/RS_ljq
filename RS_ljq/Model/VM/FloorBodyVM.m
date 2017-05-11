//
//  FloorBodyVM.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorBodyVM.h"

@implementation FloorBodyVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = VMTypeBody;
    }
    return self;
}

-(NSString *)body{
    return _body;
}
-(NSArray<NSDictionary *> *)attachments{
    return _attachments;
}
@end
