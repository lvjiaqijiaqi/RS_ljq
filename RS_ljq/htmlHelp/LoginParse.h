//
//  LoginParse.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/20.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParseParseProtocol.h"

@interface LoginParse : NSObject

+(NSString *_Nullable)HTMLParseContent:(NSString *_Nullable)content success:(nullable void (^)(NSArray *_Nullable))successBlock;

@end
