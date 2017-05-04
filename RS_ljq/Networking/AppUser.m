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

/*{succeedhandle_ls
    ('欢迎您回来，西电大三 lvjiaqijiaqi，现在将转入登录前页面',
    {'username':'lvjiaqijiaqi','usergroup':'西电大三','uid':'76373','groupid':'22','syn':'1'});
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


-(BOOL)loginStatus{
    
    return [_userDefaults objectForKey:@"userInfo"]?YES:NO;
}
-(NSString *)userName{
    return [self loginStatus]?[[_userDefaults objectForKey:@"userInfo"] objectForKey:@"username"]:@"";
}
-(NSString *)userId{
    return [self loginStatus]?[[_userDefaults objectForKey:@"userInfo"] objectForKey:@"uid"]:@"";
}


-(void)saveLoginStatus:(NSDictionary *)statusDic{
    
    [_userDefaults setObject:statusDic forKey:@"userInfo"];
    [_userDefaults synchronize];
}
-(NSDictionary *)requireLoginStatusdic{
    return [_userDefaults objectForKey:@"userInfo"];
}
-(void)clearLoginStatus{
    [_userDefaults removeObjectForKey:@"userInfo"];
    [_userDefaults synchronize];
}

@end
