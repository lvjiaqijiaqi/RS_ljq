//
//  RS_attributeStringFactory.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/26.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RS_attributeStringFactory.h"
#import <UIKit/UIKit.h>

@implementation RS_attributeStringFactory

+(NSDictionary *)PostHeaderLabelAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:style
                               };
    return dictAttr;
}

+(NSDictionary *)FloorLabelAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName:style
                               };
    return dictAttr;
}

@end
