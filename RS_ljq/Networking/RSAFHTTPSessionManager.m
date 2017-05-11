//
//  RSAFHTTPSessionManager.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RSAFHTTPSessionManager.h"

static AFHTTPSessionManager *manager ;

@implementation RSAFHTTPSessionManager

+(AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0) Gecko/20100101 Firefox/52.0" forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"rs.xidian.edu.cn" forHTTPHeaderField:@"Host"];
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"DNT"];
    });
    return manager;
}



@end
