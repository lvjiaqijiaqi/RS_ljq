//
//  ProfileModel.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel

-(NSString *)signatureStr{
    NSMutableString *mStr = [NSMutableString string];
    [_u_Signature enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *s = [NSString stringWithFormat:@"%@\n%@\n",key,obj];
        [mStr appendString:s];
    }];
    return mStr;
}
@end
