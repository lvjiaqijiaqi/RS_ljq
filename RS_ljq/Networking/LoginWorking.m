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
        if ([[AppUser sharedInstance] isLogIn]) {//本地有状态 送给cookie里面去.
            NSArray<NSHTTPCookie *> *cookiesArray = [[AppUser sharedInstance] requireLoginToCookie];
            if (cookies) {
                [storage setCookies:cookiesArray forURL:[NSURL URLWithString:[indexUrl copy]] mainDocumentURL:nil];
                return YES;
            }else{
                return NO;
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark - login

-(void)loginInRs:(NSString*)userName and:(NSString*)password success:(nullable void (^)())successBlock failure:(nullable void (^)())failureBlock{
    
    //username=lvjiaqijiaqi&password=2536044e63cc52a1715e4debe2985569&quickforward=yes&handlekey=ls
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    par[@"password"] = [self md5:@"lvjiaqi8103189"];
    par[@"username"] = @"lvjiaqijiaqi";
    par[@"quickforward"] = @"yes";
    par[@"handlekey"] = @"ls";
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager manager];
    [manager POST:[loginUrl copy] parameters:[par copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *reLoctionAddress = [LoginParse HTMLParseContent:str success:^(NSArray *cookies){
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [storage setCookies:cookies forURL:[NSURL URLWithString:[indexUrl copy]] mainDocumentURL:nil]; //储存COOKIES
        }];
        if (reLoctionAddress) {
            [self loginInRsAfter:reLoctionAddress success:successBlock failure:failureBlock];
        }else{
            //失败 清除所有cookie
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]];
            [cookies enumerateObjectsUsingBlock:^(  NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [storage deleteCookie:obj];
            }];
            failureBlock();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)loginInRsAfter:(NSString*)validUrl success:(nullable void (^)())successBlock failure:(nullable void (^)())failureBlock {
    
    AFHTTPSessionManager *manager = [RSAFHTTPSessionManager manager];
    [manager GET:validUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [[AppUser sharedInstance] saveLoginFromCookie:[storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]]];
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray<NSHTTPCookie *> *cookies = [storage cookiesForURL:[NSURL URLWithString:[indexUrl copy]]];
        [cookies enumerateObjectsUsingBlock:^( NSHTTPCookie * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [storage deleteCookie:obj];
        }];
        failureBlock();
    }];
    
}


- (NSString *)md5:(NSString *)str
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
