//
//  CornerDetailModel.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "CornerDetailModel.h"

@implementation CornerDetailModel

-(NSString *)moderatorsAddition{
    NSMutableString *str = [NSMutableString stringWithString:@"版主:"];
    [self.c_Moderators enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendString:obj];
        [str appendString:@"，"];
    }];
    return str;
}

@end
