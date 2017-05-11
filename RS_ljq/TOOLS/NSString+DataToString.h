//
//  NSString+DataToString.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/23.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DataToString)

-(NSString *)stringFromData:(NSData *)data encoding:(NSStringEncoding)encoding;
-(NSString *)clearRN:(NSString *)originStr;
-(NSInteger)requireFristInt;
+(NSString *)clearRN:(NSString *)originStr;
+(NSString *)clearMultipleRNS:(NSString *)originStr;

@end
