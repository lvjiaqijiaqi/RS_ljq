//
//  ZoneParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "HTMLNode.h"
#import "HTMLParser.h"

#import "ZoneParse.h"

#import "Post.h"
#import "Part.h"

#import "NSString+DataToString.h"

@implementation ZoneParse

-(void)HTMLParseContent:(NSString *)content{

    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    HTMLNode *bodyNode = [parser body];

    //PostLists
    Part *part = [[Part alloc] init];
    
    HTMLNode *head = [bodyNode findChildOfClass:@"bm bml pbn"];
    HTMLNode *head1 = [head findChildOfClass:@"bm_h cl"];
    HTMLNode *head2 = [head1 findChildOfClass:@"xs2"];
    part.name = [[head2 findChildTag:@"a"] allContents];
    HTMLNode *head3 = [head2 findChildOfClass:@"xs1 xw0 i"];
    
    NSArray *list1 = [head3 findChildTags:@"strong"];
    part.todayActive = [list1[0] allContents];
    part.topicsNum = [list1[1] allContents];
    part.ranking = [list1[2] allContents];
    
    NSArray *list2 = [head3 findChildTags:@"b"];
   //part.topicsNumTend = [list2[0] getAttributeNamed:@"class"];
   // part.rankingTend = [list2[1] getAttributeNamed:@"class"];

    HTMLNode *head4 = [head findChildOfClass:@"bm_c cl pbn"];
    
    NSArray *list3 = [[head4 findChildOfClass:@"xi2"] findChildTags:@"a"];
    
    NSMutableArray *moderators = [NSMutableArray arrayWithCapacity:list3.count];
    for (HTMLNode *node in list3) {
        [moderators addObject:[node allContents]];
    }
    part.moderators = [moderators copy];
    HTMLNode *head5 = [bodyNode findChildOfClass:@"ptn xg2"];
    HTMLNode *imageNode = [head5 findChildTag:@"img"];
    part.img = [imageNode getAttributeNamed:@"src"];
    part.details = [@"" clearRN:[head5 allContents]];
    _headPart = part;
    
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"threadlisttableid" allowPartial:NO];
    
    NSArray *PostListNodes = [postNode findChildTags:@"tbody"];
    NSMutableArray *PostLists = [NSMutableArray arrayWithCapacity:PostListNodes.count];
    for (HTMLNode *node in PostListNodes) {
        Post *post = [[Post alloc] init];
        HTMLNode *subNode = [[node findChildTag:@"th"] findChildOfClass:@"s xst"];
        post.name = [subNode allContents];
        if (post.name) {
            post.pid = [[subNode getAttributeNamed:@"href"] requireFristInt];
        
            NSArray *mm = [node findChildTags:@"td"];
            post.issueTime =  [[mm[1] findChildTag:@"em"] allContents];
            post.userName =  [[mm[1] findChildTag:@"a"] allContents];
            post.uid = [[[mm[1] findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt];

        
            post.reply = [[mm[2] findChildTag:@"a"] allContents];
            post.scan = [[mm[2] findChildTag:@"em"] allContents];
        
            post.lastReplyTime =  [[mm[3] findChildTag:@"em"] allContents];
            post.lastReplyUname = [[mm[3] findChildTag:@"a"] allContents];
        
            [PostLists addObject:post];
        }
    }
    _PostList = PostLists;

}

-(void)ReportError:(NSError *)error{
    
}
@end
