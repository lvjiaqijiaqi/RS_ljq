//
//  RsNetworking.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RsNetworking.h"
#import "RSAFHTTPSessionManager.h"
#import "NSData+CleanData.h"
#import "NSString+DataToString.h"

#define PC_forum @"http://rs.xidian.edu.cn/forum.php"
#define PC_Zone(fid) [NSString stringWithFormat:@"http://rs.xidian.edu.cn/forum.php?mod=forumdisplay&fid=%d",fid];
#define PC_Post(tid,page) [NSString stringWithFormat:@"http://rs.xidian.edu.cn/forum.php?mod=viewthread&tid=%d&extra=page%3D1&page=%d",tid,page];
#define PC_home @"http://rs.xidian.edu.cn/home.php?mod=spacecp"
@implementation RsNetworking

+(void)indexWithcompletionHandler:(void (^)(NSString *))completionHandler{
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager sharedHTTPSession];
    
    NSURL *URL = [NSURL URLWithString:PC_forum];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:URL];
    [cookies enumerateObjectsUsingBlock:^(  NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@:%@",obj.name,obj.value);
    }];

    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            completionHandler([[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
    }];
    [dataTask resume];
    
}

+(void)homeWithcompletionHandler:(void (^)())completionHandler{
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager sharedHTTPSession];
    NSURL *URL = [NSURL URLWithString:PC_home];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",str);
        }
    }];
    [dataTask resume];
}


//http://rs.xidian.edu.cn/forum.php?mod=forumdisplay&fid=72&filter=lastpost&orderby=lastpost最新回复
//http://rs.xidian.edu.cn/forum.php?mod=forumdisplay&fid=72&filter=hot 热帖
//http://rs.xidian.edu.cn/forum.php?mod=forumdisplay&fid=72&filter=author&orderby=dateline 最新发表
//

+(void)forumWithFilter:(ForumFilter)filter  andFid:(NSInteger)fid Page:(NSInteger)page completionHandler:(void (^)(NSString *str))completionHandler{
    NSString *url = @"http://rs.xidian.edu.cn/forum.php?mod=forumdisplay&fid=%d&filter=%@&orderby=%@&page=%d";
    switch (filter) {
        case Reply_new:
            url = [NSString stringWithFormat:url,fid,@"lastpost",@"lastpost",page];
            break;
        case Publish_new:
            url = [NSString stringWithFormat:url,fid,@"author",@"dateline",page];
            break;
        case Essence:
            url = [NSString stringWithFormat:url,fid,@"heat",@"heats",page];
        default:
            break;
    }
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager sharedHTTPSession];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSData *data = [(NSData *)responseObject UTF8Data];
            completionHandler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    [dataTask resume];

}

//http://rs.xidian.edu.cn/forum.php?mod=viewthread&tid=860952&page=1&authorid=284186

+(void)PostWithFid:(NSInteger)fid completionHandler:(void (^)(NSString *str))completionHandler{
    [self PostWithFid:fid Page:1 Authorid:0 completionHandler:completionHandler];
}
+(void)PostWithFid:(NSInteger)fid Page:(NSInteger)page completionHandler:(void (^)(NSString *str))completionHandler{
    [self PostWithFid:fid Page:page Authorid:0 completionHandler:completionHandler];
}
+(void)PostWithFid:(NSInteger)fid Page:(NSInteger)page Authorid:(NSInteger)authorid completionHandler:(void (^)(NSString *str))completionHandler{
    [self PostWithFid:fid Page:page Authorid:authorid Order:1 completionHandler:completionHandler];
}
+(void)PostWithFid:(NSInteger)fid Page:(NSInteger)page Authorid:(NSInteger)authorid Order:(NSInteger)order completionHandler:(void (^)(NSString *str))completionHandler{
    
    NSString *url = @"http://rs.xidian.edu.cn/forum.php?mod=viewthread&tid=%d&page=%d&authorid=%d&ordertype=%d";
    url = [NSString stringWithFormat:url,fid,page,authorid,order];
    //NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager sharedHTTPSession];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSData *data = [(NSData *)responseObject UTF8Data];
            completionHandler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    [dataTask resume];
}

//http://rs.xidian.edu.cn/home.php?mod=space&uid=76373&do=profile

+(void)homePage:(NSInteger)uid andType:(NSString *)type completionHandler:(void (^)(NSString *str))completionHandler{
    NSString *url = @"http://rs.xidian.edu.cn/home.php?mod=space&uid=%d&do=%@";
    url = [NSString stringWithFormat:url,uid,type];
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager sharedHTTPSession];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSData *data = [(NSData *)responseObject UTF8Data];
            completionHandler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    [dataTask resume];
    
}
@end
