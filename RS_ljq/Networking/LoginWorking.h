//
//  LoginWorking.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginWorking : NSObject

+ (instancetype)sharedInstance;
-(void)loginInRs:(NSString*)userName and:(NSString*)password success:(nullable void (^)())successBlock failure:(nullable void (^)())failureBlock;
@end
