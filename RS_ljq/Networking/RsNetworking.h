//
//  RsNetworking.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ForumFilter) {
    Reply_new = 0,
    Publish_new,
    Essence
};

@interface RsNetworking : NSObject

+(void)indexWithcompletionHandler:(void (^)(NSString *))completionHandler;
+(void)homeWithcompletionHandler:(void (^)())completionHandler;
+(void)forumWithFilter:(ForumFilter)filter  andFid:(NSInteger)fid Page:(NSInteger)page completionHandler:(void (^)(NSString *str))completionHandler;
+(void)PostWithFid:(NSInteger)fid Page:(NSInteger)page completionHandler:(void (^)(NSString *str))completionHandler;

+(void)PostWithFid:(NSInteger)fid completionHandler:(void (^)(NSString *str))completionHandler;

+(void)PostWithFid:(NSInteger)fid Page:(NSInteger)page Authorid:(NSInteger)authorid Order:(NSInteger)order completionHandler:(void (^)(NSString *str))completionHandler;

+(void)homePage:(NSInteger)uid andType:(NSString *)type completionHandler:(void (^)(NSString *str))completionHandler;
@end
