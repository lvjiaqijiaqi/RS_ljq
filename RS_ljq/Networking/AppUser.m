//
//  AppUser.m
//  RsByLjq
//
//  Created by lvjiaqi on 2016/12/4.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <objc/runtime.h>


#import "AppUser.h"

/*@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *usergroup;
@property(nonatomic,strong) NSString *groupid;
@property(nonatomic,strong) NSString *Q8qA_2132_auth; //author
@property(nonatomic,strong) NSString *Q8qA_2132_lastact;
@property(nonatomic,strong) NSString *Q8qA_2132_lip;
@property(nonatomic,strong) NSString *Q8qA_2132_sid;
@property(nonatomic,strong) NSString *Q8qA_2132_lastcheckfeed;
@property(nonatomic,strong) NSString *Q8qA_2132_myrepeat_rr;
@property(nonatomic,strong) NSString *Q8qA_2132_ulastactivity;
@property(nonatomic,strong) NSString *Q8qA_2132_saltkey;
@property(nonatomic,strong) NSString *Q8qA_2132_lastvisit;
*/



@implementation AppUser


static AppUser *_instance;

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
        _instance.userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [AppUser sharedInstance];
}


-(BOOL)isLogIn{
    return [[_userDefaults objectForKey:@"loginUser"] boolValue];
}
-(void)logOut{
    [_userDefaults setBool:NO forKey:@"loginUser"];
    [_userDefaults removeObjectForKey:@"userInfo"];
    [_userDefaults synchronize];
}

-(void)saveLoginFromCookie:(NSArray<NSHTTPCookie *>*)cookies{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:10];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [userInfo setValue:obj.value forKey:obj.name];
    }];
    [_userDefaults setBool:YES forKey:@"loginUser"];
    [_userDefaults setObject:userInfo forKey:@"userInfo"];
    [_userDefaults synchronize];
}



-(NSArray<NSHTTPCookie *> *)requireLoginToCookie{
    NSMutableDictionary *cookiesArr = [_userDefaults objectForKey:@"userInfo"];
    NSMutableArray *cookies = [NSMutableArray array];
    if (cookiesArr) {
        [cookiesArr enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop){
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
    }
    return cookies;
}


@end
