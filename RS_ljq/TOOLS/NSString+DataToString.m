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
+(NSString *)clearRN:(NSString *)originStr{
    NSString *str = [originStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}

+(NSString *)clearMultipleRNS:(NSString *)originStr{
    NSMutableString *string = [NSMutableString stringWithString:originStr];
    int i = 0;
    while ( i < string.length) {
        if ([[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"\n"]) {
            i++;
            while (i < string.length && [[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"\n"]) {
                [string deleteCharactersInRange:NSMakeRange(i, 1)];
            }
        }else{
            i++;
        }
    }
    return string;
    
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

+(BOOL)isEmailAddress:(NSString*)candidate
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)isUserName
{
    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}
@end
