//
//  RSparse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/24.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "RSparse.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@implementation RSparse


-(BOOL)HTMLParseLoginState:(HTMLNode *)rootNode{
    HTMLNode *uNode = [rootNode findChildWithAttribute:@"id" matchingName:@"um" allowPartial:NO];
    if (!uNode) {
        return NO;
    }
    return YES;
}

-(HTMLNode *)HTMLNodeParseContents:(NSString *)content{
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    if (error) [self ReportError:error];
    HTMLNode *bodyNode = [parser body];
    return bodyNode;
    
}

-(void)ReportError:(NSError *)error{
    
}
@end
