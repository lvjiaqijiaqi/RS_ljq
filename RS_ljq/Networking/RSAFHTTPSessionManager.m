//
//  RSAFHTTPSessionManager.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RSAFHTTPSessionManager.h"

@implementation RSAFHTTPSessionManager

-(instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration{
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self = [super initWithBaseURL:url sessionConfiguration:defaultConfiguration];
    if (!self) {
        return nil;
    }
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0) Gecko/20100101 Firefox/52.0" forHTTPHeaderField:@"User-Agent"];
    [self.requestSerializer setValue:@"rs.xidian.edu.cn" forHTTPHeaderField:@"Host"];
    [self.requestSerializer setValue:@"1" forHTTPHeaderField:@"DNT"];
    
    return self;
}


@end
