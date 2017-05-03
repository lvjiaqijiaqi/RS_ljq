//
//  HomeParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "HomeParse.h"

#import "HTMLNode.h"
#import "HTMLParser.h"

#import "ProfileModel.h"

#import "NSString+DataToString.h"

@interface HomeParse()


@end

@implementation HomeParse

-(void)HTMLParseContentOfProfile:(NSString *)content{
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode= [parser body];

    if([bodyNode findChildOfClass:@"alert_error"]){ //用户不存在,直接return;
            _pModel = nil;
            return;
    }
    
    ProfileModel *pModel =  [[ProfileModel alloc] init];
    
    HTMLNode *profileNode = [[[bodyNode findChildOfClass:@"mn"] findChildOfClass:@"bm"] findChildOfClass:@"bm_c u_profile"];
    NSArray *profilesList = [profileNode findChildTags:@"div"];
    HTMLNode *personalDataNode = [profileNode findChildOfClass:@"pbm mbm bbda cl"];
    
    pModel.u_Name = [@"" clearRN:[[personalDataNode findChildOfClass:@"mbn"] allContents]];
    pModel.u_Id = [[[[personalDataNode findChildOfClass:@"mbn"] findChildOfClass:@"xw0"] allContents] requireFristInt];
    
    NSArray *ulNodes = [personalDataNode findChildTags:@"ul"];
    NSArray *liNodes = [ulNodes[1] findChildTags:@"li"];
    NSMutableDictionary *Signature = [NSMutableDictionary dictionary];
    [liNodes enumerateObjectsUsingBlock:^(HTMLNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj findChildTag:@"em"] allContents];
        NSString *val = [[obj allContents] substringFromIndex:key.length];
        [Signature setValue:val forKey:key];
    }];
    pModel.u_Signature = [Signature copy];
    
    NSArray *as = [ulNodes[2] findChildTags:@"a"];
    NSMutableArray *statistical = [NSMutableArray array];
    [as enumerateObjectsUsingBlock:^(HTMLNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [statistical addObject:[NSNumber numberWithInteger:[[obj allContents] requireFristInt]]];
    }];
    pModel.u_Statistical = [statistical copy];
    
    
    if (ulNodes.count >= 4 ) {
        liNodes = [ulNodes[3] findChildTags:@"li"];
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        [liNodes enumerateObjectsUsingBlock:^(HTMLNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = [[obj findChildTag:@"em"] allContents];
            NSString *val = [obj allContents];
            [details setValue:val forKey:key];
        }];
        pModel.u_Details = [details copy];
    }
    
    HTMLNode *signInNode = profilesList[1];
    NSArray *ps = [signInNode findChildTags:@"p"];
    pModel.u_signInTotal = [[ps[0] findChildTag:@"b"] allContents];
    pModel.u_signInMonth = [[ps[1] findChildTag:@"b"] allContents];
    pModel.u_signInLastTime = [[ps[2] findChildTag:@"b"] allContents];
    
    NSArray *ss = [ps[3] findChildTags:@"b"];
    pModel.u_AwardTotal = [[ss[0] allContents] requireFristInt];
    pModel.u_AwardLast = [[ss[0] allContents] requireFristInt];
    
    NSArray *sss = [ps[4] findChildTags:@"b"];
    pModel.u_signInGrade = [sss[0] allContents];
    pModel.u_signInNextGrade = [sss[1] allContents];
    pModel.u_signInNextGradeTime = [sss[2] allContents];

    pModel.u_signInStatus = [ps[5] allContents];
    
    NSArray *ulss = [profilesList[2] findChildTags:@"ul"];
    NSMutableArray *groupInformation =  [NSMutableArray array];
    [groupInformation addObject:[[ulss[0] findChildTag:@"span"] allContents]];
    [groupInformation addObject:[[ulss[0] findChildTag:@"span"] getAttributeNamed:@"tip"]];
    pModel.u_GroupInformation = [groupInformation copy];
    
    NSArray *lissss = [ulss[1] findChildTags:@"li"];
    NSMutableDictionary *activeInformation = [NSMutableDictionary dictionary];
    [lissss enumerateObjectsUsingBlock:^(HTMLNode *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj findChildTag:@"em"] allContents];
        NSString *val = [obj allContents];
        [activeInformation setValue:val forKey:key];
    }];
    pModel.u_ActiveInformation = [activeInformation copy];
    
    NSArray *liss = [profilesList[3] findChildTags:@"li"];
    NSMutableDictionary *StatisticalInformation = [NSMutableDictionary dictionary];
    [liss enumerateObjectsUsingBlock:^(HTMLNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj findChildTag:@"em"] allContents];
        NSString *val = [obj allContents];
        [StatisticalInformation setValue:val forKey:key];
    }];
    pModel.u_StatisticalInformation = [StatisticalInformation copy];
    
    pModel.u_HeadImage = [[[[bodyNode findChildOfClass:@"sd"] findChildOfClass:@"hm"] findChildTag:@"img"] getAttributeNamed:@"src"];
    
    _pModel = pModel;
    
}

@end
