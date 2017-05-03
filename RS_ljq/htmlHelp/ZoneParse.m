//
//  ZoneParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//
#import "ZoneParse.h"

#import "HTMLNode.h"
#import "HTMLParser.h"

#import "ForumTopicModel.h"
#import "CornerDetailModel.h"

#import "NSString+DataToString.h"

@implementation ZoneParse

-(void)HTMLParseContent:(NSString *)content{

    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode = [parser body];

    //PostLists
    CornerDetailModel *corner = [[CornerDetailModel alloc] init];
    
    HTMLNode *head = [bodyNode findChildOfClass:@"bm bml pbn"];
    HTMLNode *head1 = [head findChildOfClass:@"bm_h cl"];
    HTMLNode *head2 = [head1 findChildOfClass:@"xs2"];
    corner.c_Name = [[head2 findChildTag:@"a"] allContents];
    HTMLNode *head3 = [head2 findChildOfClass:@"xs1 xw0 i"];
    
    NSArray *list1 = [head3 findChildTags:@"strong"];
    corner.c_TodayActive = [list1[0] allContents];
    corner.c_TopicNum = [list1[1] allContents];
    corner.c_Ranking = [list1[2] allContents];
    
    NSArray *list2 = [head3 findChildTags:@"b"];
    [list2 enumerateObjectsUsingBlock:^(HTMLNode*  _Nonnull obj, NSUInteger c, BOOL * _Nonnull stop) {
        if (c == 0) {
            corner.c_TopicsNumTend = [obj getAttributeNamed:@"class"];
        }else if(c == 1){
            corner.c_RankingTend = [obj getAttributeNamed:@"class"];
        }
    }];

    HTMLNode *head4 = [head findChildOfClass:@"bm_c cl pbn"];
    
    NSArray *list3 = [[head4 findChildOfClass:@"xi2"] findChildTags:@"a"];
    
    NSMutableArray *moderators = [NSMutableArray arrayWithCapacity:list3.count];
    for (HTMLNode *node in list3) {
        [moderators addObject:[node allContents]];
    }
    corner.c_Moderators = [moderators copy];
    HTMLNode *head5 = [bodyNode findChildOfClass:@"ptn xg2"];
    HTMLNode *imageNode = [head5 findChildTag:@"img"];
    corner.c_HeaderImg = [imageNode getAttributeNamed:@"src"];
    corner.c_Details = [@"" clearRN:[head5 allContents]];
    _corner = corner;
    
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"threadlisttableid" allowPartial:NO];
    
    NSArray *PostListNodes = [postNode findChildTags:@"tbody"];
    NSMutableArray *TopicLists = [NSMutableArray arrayWithCapacity:PostListNodes.count];
    for (HTMLNode *node in PostListNodes) {
        ForumTopicModel *topic = [[ForumTopicModel alloc] init];
        HTMLNode *subNode = [[node findChildTag:@"th"] findChildOfClass:@"s xst"];
        topic.t_Name = [subNode allContents];
        if (topic.t_Name) {
            topic.t_Id = [[subNode getAttributeNamed:@"href"] requireFristInt];
        
            NSArray *mm = [node findChildTags:@"td"];
            topic.t_issueTime =  [[mm[1] findChildTag:@"em"] allContents];
            topic.t_userName =  [[mm[1] findChildTag:@"a"] allContents];
            topic.t_Uid = [[[mm[1] findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt];

            topic.t_replyNum = [[mm[2] findChildTag:@"a"] allContents];
            topic.t_scanNum = [[mm[2] findChildTag:@"em"] allContents];
        
            topic.t_lastReplyTime =  [[mm[3] findChildTag:@"em"] allContents];
            topic.t_lastReplyUname = [[mm[3] findChildTag:@"a"] allContents];
        
            [TopicLists addObject:topic];
        }
    }
    _topicList = TopicLists;

}

-(void)ReportError:(NSError *)error{
    
}
@end
