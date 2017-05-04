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

+(NSDictionary *)HTMLParseContent:(NSString *)content;

@end
