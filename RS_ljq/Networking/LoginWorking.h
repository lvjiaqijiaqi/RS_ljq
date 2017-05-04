//
//  LoginWorking.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginWorking : NSObject

+ (instancetype _Nullable )sharedInstance;
-(void)loginInRs:(NSString*_Nullable)userName and:(NSString*_Nullable)password success:(nullable void (^)(NSString * _Nullable msg))successBlock failure:(nullable void (^)(NSString * _Nullable msg))failureBlock;
@end
