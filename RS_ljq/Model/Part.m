//
//  Part.m
//  rs
//
//  Created by lvjiaqi on 16/6/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "Part.h"

@implementation Part


-(NSString *)additionStr{
     NSMutableString *str = [NSMutableString stringWithString:@"版主:"];
     [self.moderators enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [str appendString:obj];
         [str appendString:@"，"];
     }];
    return str;
}
@end
