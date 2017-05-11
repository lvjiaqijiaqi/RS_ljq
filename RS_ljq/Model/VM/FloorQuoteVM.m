//
//  FloorQuoteVM.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorQuoteVM.h"

@implementation FloorQuoteVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = VMTypeQuote;
    }
    return self;
}
-(NSString *)body{
    return _body;
}

@end
