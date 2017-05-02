//
//  AppUser.h
//  RsByLjq
//
//  Created by lvjiaqi on 2016/12/4.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RsUser : NSObject<NSCoding>
@property(nonatomic,strong) NSString *username;
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
@end

@interface AppUser : NSObject

@property(nonatomic,strong) NSUserDefaults *userDefaults;

-(void)saveLoginFromCookie:(NSArray<NSHTTPCookie *>*)cookies;
-(NSArray<NSHTTPCookie *> *)requireLoginToCookie;

+ (instancetype)sharedInstance;
-(BOOL)isLogIn;
-(void)logOut;

@end
