//
//  NSString+DataToString.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/23.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "NSString+DataToString.h"
#include "iconv.h"

@implementation NSString (DataToString)

-(NSString *)clearRN:(NSString *)originStr{
    NSString *str = [originStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
-(NSInteger)requireFristInt{
    NSInteger i = 0;
    NSScanner *theScanner = [NSScanner scannerWithString:self];
    [theScanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    [theScanner scanInteger:&i];
    return i;
}

-(NSString *)stringFromData:(NSData *)data encoding:(NSStringEncoding)encoding{
    NSInteger DataLen = data.length;
    NSInteger segLen = 5000;
    NSInteger times = DataLen/segLen;
    NSInteger fristLen = DataLen%segLen;
    NSMutableString *str = [NSMutableString string];
    [str appendString:[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, fristLen)] encoding:encoding]];
    NSLog(@"%@",str);
    while (times--) {
        NSData *subdata = [data subdataWithRange:NSMakeRange(fristLen, segLen)] ;
        if (subdata) {
            NSString*substr = [[NSString alloc] initWithData:subdata encoding:encoding]; //tag1
            if (substr) {
                [str appendString:substr];
                 NSLog(@"%@",substr);
            }
            fristLen += segLen;
        }else{
            break;
        }
    }
    return str;
}

@end
