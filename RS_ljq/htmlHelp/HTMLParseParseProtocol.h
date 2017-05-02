//
//  HTMLParseParseProtocol.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTMLParseParseProtocol <NSObject>

-(void)HTMLParseContent:(NSString *)content;
-(void)ReportError:(NSError *)error;

@end
