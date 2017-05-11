//
//  RS_attributeStringFactory.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/26.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RS_attributeStringFactory.h"
#import <UIKit/UIKit.h>

#define colorWithRGBValue(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
                 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//! 参数格式为：222,222,222
#define colorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]
// @end

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


+(NSDictionary *)postBodyAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 5;
    style.paragraphSpacing = 10;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0x515151)
                               };
    return dictAttr;
}

+(NSDictionary *)postPstatusAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0xbfbfbf)
                               };
    return dictAttr;
}
+(NSDictionary *)postQuoteAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0x707070)
                               };
    return dictAttr;
}


+(NSDictionary *)postCommentUnameAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.paragraphSpacingBefore = 10;
    style.paragraphSpacing = 0;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0x1296db)
                               };
    return dictAttr;
}

+(NSDictionary *)postCommentPublicTimeAttribute{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentRight;
    style.paragraphSpacingBefore = 0;
    //0xbfbfbf
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0xbfbfbf)
                               };
    return dictAttr;
}
+(NSDictionary *)postCommentBodyAttribute{
    //1296db//
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.paragraphSpacingBefore = 5;
    NSDictionary *dictAttr = @{
                               NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:colorWithRGBValue(0x515151)
                               };
    return dictAttr;
}
@end
