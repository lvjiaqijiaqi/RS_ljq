//
//  LoginWorking.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "LoginWorking.h"
#import <AFNetworking.h>
#import "LoginParse.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppUser.h"
#import "RSAFHTTPSessionManager.h"

static const NSString *loginUrl = @"http://rs.xidian.edu.cn/member.php?mod=logging&action=login&loginsubmit=yes&frommessage&loginhash=LmEp3&inajax=1";
static const NSString *indexUrl = @"http://rs.xidian.edu.cn";
static const NSString *forumUrl = @"http://rs.xidian.edu.cn/forum.php";
static const NSString *authorName = @"Q8qA_2132_auth";

@implementation LoginWorking

static LoginWorking *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return [LoginWorking sharedInstance];
}


-(BOOL)recoverCookies{
    NSMutableArray *cookies = [NSMutableArray array];
    if ([[AppUser sharedInstance] requireLoginStatusdic]) {
        [[[AppUser sharedInstance] requireLoginStatusdic] enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop){
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
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [storage setCookies:cookies forURL:[NSURL URLWithString:[indexUrl copy]] mainDocumentURL:nil];
        return YES;
    }
    return NO;
}

-(BOOL)validLoginState{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]];
    __block bool isCookie = NO;
    [cookies enumerateObjectsUsingBlock:^( NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:[authorName copy]]) {
            *stop = YES;
            ![obj.value isEqualToString:@""]&&(isCookie = YES);
        }
    }];
    if (!isCookie) {
        return [self recoverCookies];
    }
    return YES;
}


#pragma mark - login

-(void)loginInRs:(NSString*)userName and:(NSString*)password success:(nullable void (^)(NSString *msg))successBlock failure:(nullable void (^)(NSString *msg))failureBlock{
    
  //username=lvjiaqijiaqi&password=2536044e63cc52a1715e4debe2985569&quickforward=yes&handlekey=ls
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    par[@"password"] = [self md5:password];
    par[@"username"] = userName;
    par[@"quickforward"] = @"yes";
    par[@"handlekey"] = @"ls";
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager manager];
    
    [self clearLoginStatus];
    
    [manager POST:[loginUrl copy] parameters:[par copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *loginDic  = [LoginParse HTMLParseContent:str];
        if ([[loginDic objectForKey:@"status"] boolValue]) { //success
            [self loginInRsAfter:loginDic  success:successBlock failure:failureBlock];
        }else{
            [self clearLoginStatus];
            failureBlock(@"登陆失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"网络错误");
    }];
    
}

-(void)loginInRsAfter:(NSDictionary*)loginDic success:(nullable void (^)(NSString *msg))successBlock failure:(nullable void (^)(NSString *msg))failureBlock {
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager manager];
    [manager GET:[loginDic objectForKey:@"reLocationAddress"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self storeStatus:loginDic];
        successBlock([NSString stringWithFormat:@"%@  %@",[loginDic objectForKey:@"username"],[loginDic objectForKey:@"usergroup"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self clearLoginStatus];
        failureBlock(@"登陆失败");
    }];
}


#pragma mark - loginStatusHandle

-(void)clearLoginStatus{
    [[AppUser sharedInstance] clearLoginStatus];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]];
    [cookies enumerateObjectsUsingBlock:^(  NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [storage deleteCookie:obj];
    }];
}
-(void)storeStatus:(NSDictionary *)dic{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setDictionary:dic];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]];
    [cookies enumerateObjectsUsingBlock:^(  NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [userDic setValue:obj.value forKey:obj.name];
        NSLog(@"%@:%@",obj.name,obj.value);
    }];
    [[AppUser sharedInstance] saveLoginStatus:[userDic copy]];
    
}



-(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
