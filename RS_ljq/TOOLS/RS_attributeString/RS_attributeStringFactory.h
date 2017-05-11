//
//  RS_attributeStringFactory.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/26.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RS_attributeStringFactory : NSObject

+(NSDictionary *)PostHeaderLabelAttribute;
+(NSDictionary *)FloorLabelAttribute;
+(NSDictionary *)pstatusAttribute;
+(NSDictionary *)quoteAttribute;
+(NSDictionary *)bodyAttribute;

+(NSDictionary *)postQuoteAttribute;
+(NSDictionary *)postPstatusAttribute;
+(NSDictionary *)postBodyAttribute;

+(NSDictionary *)postCommentUnameAttribute;
+(NSDictionary *)postCommentPublicTimeAttribute;
+(NSDictionary *)postCommentBodyAttribute;
@end
