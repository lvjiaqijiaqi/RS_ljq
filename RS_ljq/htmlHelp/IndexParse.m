//
//  IndexParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//
#import "IndexParse.h"

#import "HTMLNode.h"
#import "HTMLParser.h"

#import "TopicModel.h"


#import "IndexUsrRankingModel.h"
#import "CornerModel.h"

#import "NSString+DataToString.h"

#define newTopicDivName "portal_block_314_content"
#define replyTopicDivName "portal_block_315_content"
#define recomendTopicDivName "portal_block_313_content"
#define dayHotTopicDivName "portal_block_316_content"
#define weekHotTopicDivName "portal_block_350_content"
#define imageTopicDivName "portal_block_321_content"
#define userRankingDivName "portal_block_317_content"
#define forumDetailDivName "chart"
#define catsClassName "fl bm"
#define catClassName "bm bmw  flg cl"
#define onlineDivName "online"

@implementation IndexParse


-(NSArray<TopicModel *>*)IndexTopicList:(NSString *)DIVNAME ofCat:(TopicCat)topicCat onRootNode:(HTMLNode*)rootNode{
    HTMLNode * postNode = [rootNode findChildWithAttribute:@"id" matchingName:DIVNAME allowPartial:NO];
    NSArray<HTMLNode *> *topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<TopicModel *>* topicLisArr = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopicModel *topicModel = [[TopicModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        topicModel.t_Name = [contentNodes[0] allContents];
        topicModel.t_Addition = [contentNodes[0] getAttributeNamed:@"title"];
        topicModel.t_Id = [[contentNodes[0] getAttributeNamed:@"href"] requireFristInt];
        topicModel.t_userName = [[obj findChildTag:@"em"] allContents];
        topicModel.t_Cat = topicCat;
        
        [topicLisArr addObject:topicModel];
    }];
    
    return [topicLisArr copy];
}


-(void)HTMLParseContent:(NSString *)content{
  
    //NSLog(@"%@",content);
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode = [parser body];
    
    
    //topicLis_imgHot
    HTMLNode * postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@imageTopicDivName allowPartial:NO];
    NSArray<HTMLNode *> *topicLis =  [postNode findChildTags:@"li"];
    
    NSMutableArray<TopicModel *>* topicLis_imgHot = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopicModel *topicModel = [[TopicModel alloc] init];
        topicModel.t_Id = [[[obj findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt];
        topicModel.t_Img = [NSString stringWithFormat:@"http://rs.xidian.edu.cn%@",[[[obj findChildTag:@"img"] getAttributeNamed:@"src"] substringFromIndex:1]];
        topicModel.t_Name = [[obj findChildTag:@"span"] allContents];
        [topicLis_imgHot addObject:topicModel];
    }];
    _topicLis_imgHot = topicLis_imgHot;
    
    _topicLis_new = [self IndexTopicList:@newTopicDivName ofCat:RS_topicNew onRootNode:bodyNode];
    _topicLis_newReply = [self IndexTopicList:@replyTopicDivName ofCat:RS_topicLastReply onRootNode:bodyNode];
    _topicLis_recommend = [self IndexTopicList:@recomendTopicDivName ofCat:RS_topicRecomend onRootNode:bodyNode];
    _topicLis_dayHot = [self IndexTopicList:@recomendTopicDivName ofCat:RS_topicDayHot onRootNode:bodyNode];
    _topicLis_dayHot = [self IndexTopicList:@weekHotTopicDivName ofCat:RS_topicWeekHot onRootNode:bodyNode];
    
    
    
    //userRankings
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@userRankingDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexUsrRankingModel *>* userRankings = [NSMutableArray arrayWithCapacity:20];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexUsrRankingModel *IndexNewTopic = [[IndexUsrRankingModel alloc] init];
        HTMLNode *contentA = [obj findChildTag:@"a"];
        IndexNewTopic.userImageUrl = [contentA getAttributeNamed:@"href"];
        NSArray<HTMLNode *> *contentPs = [obj findChildTags:@"p"];
        IndexNewTopic.userName = [contentPs[0] allContents];
        IndexNewTopic.userScore = [contentPs[1] allContents];
        [userRankings addObject:IndexNewTopic];
    }];
    _userRankings = userRankings;
    
    //zone分区
    HTMLNode *zoneNode = [bodyNode findChildOfClass:@"fl bm"];
    NSArray *zones = [zoneNode findChildrenOfClass:@"bm bmw  flg cl"];
    NSMutableDictionary *zoneLists = [NSMutableDictionary dictionaryWithCapacity:zones.count];
    
    [zones enumerateObjectsUsingBlock:^(HTMLNode *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj findChildWithAttribute:@"id" matchingName:@"category_0" allowPartial:NO]){
            
        }else{
        NSString *zoneName = [[[obj findChildOfClass:@"bm_h cl"] findChildTag:@"h2"] allContents];
        NSArray *TrNodes = [obj findChildTags:@"td"];
            
        NSMutableArray<CornerModel *> *subZoneLists = [NSMutableArray arrayWithCapacity:TrNodes.count];
        for (HTMLNode *node in TrNodes) {
            CornerModel *m =  [[CornerModel alloc] init];
            NSString *imgUrl = [[node findChildTag:@"img"] getAttributeNamed:@"src"];
            if (imgUrl) {
                m.c_Img = [NSString stringWithFormat:@"http://rs.xidian.edu.cn%@",[imgUrl substringFromIndex:1]];
                m.c_Name = [[[node findChildTag:@"dt"] findChildTag:@"a"] allContents];
                m.c_Id =  [[[[node findChildTag:@"dt"] findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt];
                m.c_Active = [[[node findChildTag:@"dt"] findChildTag:@"em"] allContents];
            
                NSArray *dds = [node findChildTags:@"dd"];
                NSArray *ems = [dds[0] findChildTags:@"em"];
                m.c_TopicNum = [ems[0] allContents];
                m.c_PostNum = [ems[1] allContents];
                m.c_LastActive =  [dds[1] allContents];
                [subZoneLists addObject:m];
                }
            }
            [zoneLists setObject:subZoneLists forKey:zoneName];
        }
    }];
        _zoneLists = zoneLists;
}

-(void)ReportError:(NSError *)error{

}

@end
