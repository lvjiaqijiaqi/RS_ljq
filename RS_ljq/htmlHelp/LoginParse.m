//
//  LoginParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "LoginParse.h"
#import "HTMLParser.h"
#import "IndexParse.h"

@implementation LoginParse

+(NSString *)HTMLParseContent:(NSString *)content success:(nullable void (^)(NSArray *))successBlock{
    
    NSLog(@"%@",content);
    NSError *error;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"script"];
    NSString *reLocationAddress = [inputNodes[0] getAttributeNamed:@"src"];
    NSMutableArray *cookies = nil;
    if ([inputNodes count] > 1) {
        NSRange startRange = [content rangeOfString:@"{'username"];
        unsigned long start = startRange.location;
        unsigned long end = [[content substringFromIndex:startRange.location] rangeOfString:@"}"].location;
        NSString *userStr = [content substringWithRange:NSMakeRange(start, end+1)];
        userStr = [userStr stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
        NSData* jsonData = [userStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        cookies = [NSMutableArray arrayWithCapacity:5];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];  // 创建cookie属性字典
            [cookieProperties setObject:key forKey:NSHTTPCookieName]; // 手动设置cookie的属性
            [cookieProperties setObject:obj forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@"rs.xidian.edu.cn" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@"rs.xidian.edu.cn" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [cookies addObject:cookie];
        }];
        successBlock(cookies);
        return reLocationAddress;
    }
    return nil;
}



@end

