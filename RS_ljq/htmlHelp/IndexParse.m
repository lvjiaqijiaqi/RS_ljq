//
//  IndexParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "IndexParse.h"
#import "IndexImageModel.h"
#import "IndexTopicRandingModel.h"
#import "IndexUsrRankingModel.h"
#import "IndexZoneModel.h"
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

-(void)HTMLParseContent:(NSString *)content{
  
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode = [parser body];
    
    // topicLis_new
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@newTopicDivName allowPartial:NO];
    NSArray<HTMLNode *> *topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexTopicRandingModel *>* topicLis_new = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexTopicRandingModel *IndexNewTopic = [[IndexTopicRandingModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        IndexNewTopic.topicName = [contentNodes[0] allContents];
        IndexNewTopic.topicUser = [contentNodes[1] allContents];
        IndexNewTopic.topicAddition = [contentNodes[0] getAttributeNamed:@"title"];
        IndexNewTopic.topicId = [contentNodes[0] getAttributeNamed:@"href"];
        IndexNewTopic.topicCategory = RS_topicNew;
        [topicLis_new addObject:IndexNewTopic];
    }];
    _topicLis_new = topicLis_new;
    
    //topicLis_imgHot
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@imageTopicDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexImageModel *>* topicLis_imgHot = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexImageModel *IndexNewTopic = [[IndexImageModel alloc] init];
        
        IndexNewTopic.topicId = [[[obj findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt]; 
        HTMLNode *contentA = [obj findChildTag:@"img"];
        IndexNewTopic.imageUrl = [contentA getAttributeNamed:@"src"];
        IndexNewTopic.imageUrl =  [IndexNewTopic.imageUrl substringWithRange:NSMakeRange(1, [IndexNewTopic.imageUrl length] - 1)];
        IndexNewTopic.imageUrl = [NSString stringWithFormat:@"http://rs.xidian.edu.cn%@",IndexNewTopic.imageUrl];
        HTMLNode *emNode = [obj findChildTag:@"span"];
        IndexNewTopic.imageTitle = [emNode allContents];
        [topicLis_imgHot addObject:IndexNewTopic];
    }];
    _topicLis_imgHot = topicLis_imgHot;
    
    //topicLis_newReply
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@replyTopicDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexTopicRandingModel *>* topicLis_newReply = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexTopicRandingModel *IndexNewTopic = [[IndexTopicRandingModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        IndexNewTopic.topicName = [contentNodes[0] allContents];
        IndexNewTopic.topicAddition = [contentNodes[0] getAttributeNamed:@"title"];
        IndexNewTopic.topicId = [[contentNodes[0] getAttributeNamed:@"href"] requireFristInt];
        NSArray<HTMLNode *> *emNodes = [obj findChildTags:@"em"];
        IndexNewTopic.topicUser = [emNodes[0] allContents];
        IndexNewTopic.topicCategory = RS_topicLastReply;
        [topicLis_newReply addObject:IndexNewTopic];
    }];
    _topicLis_newReply = topicLis_newReply;
    
    //topicLis_recommend
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@recomendTopicDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexTopicRandingModel *>* topicLis_recommend = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexTopicRandingModel *IndexNewTopic = [[IndexTopicRandingModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        IndexNewTopic.topicName = [contentNodes[0] allContents];
        IndexNewTopic.topicAddition = [contentNodes[0] getAttributeNamed:@"title"];
        IndexNewTopic.topicId = [[contentNodes[0] getAttributeNamed:@"href"] requireFristInt];
        NSArray<HTMLNode *> *emNodes = [obj findChildTags:@"em"];
        IndexNewTopic.topicUser = [emNodes[0] allContents];
        IndexNewTopic.topicCategory = RS_topicRecomend;
        [topicLis_recommend addObject:IndexNewTopic];
    }];
    _topicLis_recommend = topicLis_recommend;
    
    //_topicLis_dayHot
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@recomendTopicDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexTopicRandingModel *>* topicLis_dayHot = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexTopicRandingModel *IndexNewTopic = [[IndexTopicRandingModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        IndexNewTopic.topicName = [contentNodes[0] allContents];
        IndexNewTopic.topicAddition = [contentNodes[0] getAttributeNamed:@"title"];
        IndexNewTopic.topicId = [[contentNodes[0] getAttributeNamed:@"href"] requireFristInt];
        NSArray<HTMLNode *> *emNodes = [obj findChildTags:@"em"];
        IndexNewTopic.topicUser = [emNodes[0] allContents];
        IndexNewTopic.topicCategory = RS_topicDayHot;
        [topicLis_dayHot addObject:IndexNewTopic];
    }];
    _topicLis_dayHot = topicLis_dayHot;
    
    //_topicLis_weekHot
    postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@weekHotTopicDivName allowPartial:NO];
    topicLis =  [postNode findChildTags:@"li"];
    NSMutableArray<IndexTopicRandingModel *>* topicLis_weekHot = [NSMutableArray arrayWithCapacity:10];
    [topicLis enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IndexTopicRandingModel *IndexNewTopic = [[IndexTopicRandingModel alloc] init];
        NSArray<HTMLNode *> *contentNodes = [obj findChildTags:@"a"];
        IndexNewTopic.topicName = [contentNodes[0] allContents];
        IndexNewTopic.topicAddition = [contentNodes[0] getAttributeNamed:@"title"];
        IndexNewTopic.topicId = [[contentNodes[0] getAttributeNamed:@"href"] requireFristInt];
        NSArray<HTMLNode *> *emNodes = [obj findChildTags:@"em"];
        IndexNewTopic.topicUser = [emNodes[0] allContents];
        IndexNewTopic.topicCategory = RS_topicDayHot;
        [topicLis_weekHot addObject:IndexNewTopic];
    }];
    _topicLis_weekHot = topicLis_weekHot;
    
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
    
    //zone分区类别
    HTMLNode *zoneNode = [bodyNode findChildOfClass:@"fl bm"];
    NSArray *zones = [zoneNode findChildrenOfClass:@"bm bmw  flg cl"];
    NSMutableDictionary *zoneLists = [NSMutableDictionary dictionaryWithCapacity:zones.count];
    
    [zones enumerateObjectsUsingBlock:^(HTMLNode *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj findChildWithAttribute:@"id" matchingName:@"category_0" allowPartial:NO]){
            
        }else{
        NSString *zoneName = [[[obj findChildOfClass:@"bm_h cl"] findChildTag:@"h2"] allContents];
        NSArray *TrNodes = [obj findChildTags:@"td"];
            
        NSMutableArray *subZoneLists = [NSMutableArray arrayWithCapacity:TrNodes.count];
        for (HTMLNode *node in TrNodes) {
            IndexZoneModel *m =  [[IndexZoneModel alloc] init];
            m.img = [[node findChildTag:@"img"] getAttributeNamed:@"src"];
            if (m.img) {
                m.img =  [m.img substringWithRange:NSMakeRange(1, [m.img length] - 1)];
                m.img = [NSString stringWithFormat:@"http://rs.xidian.edu.cn%@",m.img];
                m.name = [[[node findChildTag:@"dt"] findChildTag:@"a"] allContents];
                NSString *urlSSS = [[[node findChildTag:@"dt"] findChildTag:@"a"] getAttributeNamed:@"href"];
                
                m.zid =  [urlSSS requireFristInt];
                
                m.active = [[[node findChildTag:@"dt"] findChildTag:@"em"] allContents];
            
                NSArray *dds = [node findChildTags:@"dd"];
            
                NSArray *ems = [dds[0] findChildTags:@"em"];
                m.topicNum = [ems[0] allContents];
                m.topics = [ems[1] allContents];
            
                m.lastActive =  [dds[1] allContents];
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
