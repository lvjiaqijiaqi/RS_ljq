//
//  ForumParse.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "HTMLNode.h"
#import "HTMLParser.h"
#import "ForumParse.h"
#import "NSString+DataToString.h"

#import "Floor.h"
#import "ForumTopicModel.h"

@implementation ForumParse

-(NSMutableArray *)parseRate:(HTMLNode *)rateNode{
    
    NSArray *rateList = [[rateNode findChildOfClass:@"ratl_l"] findChildTags:@"tr"];
    NSMutableArray *rateArr = [NSMutableArray arrayWithCapacity:rateList.count];
    
    for (HTMLNode *rate in rateList) {
        NSArray *tds = [rate findChildTags:@"td"];
        NSDictionary *rate = [NSDictionary dictionaryWithObjectsAndKeys:[tds[0] allContents],@"name",[tds[1] allContents],@"money",[tds[2] allContents],@"star",[tds[3] allContents],@"reason", nil];
        [rateArr addObject:rate];
    }
    
    return rateArr;
}
-(NSMutableArray *)parseComment:(HTMLNode *)cmNode{
    
    NSArray * cmList = [cmNode findChildrenOfClass:@"pstl xs1 cl"];
    NSMutableArray *cmListArr = [NSMutableArray arrayWithCapacity:cmList.count];
    
    for(HTMLNode *cm in cmList){
        HTMLNode *name = [cm findChildOfClass:@"xi2 xw1"];
        HTMLNode *context = [cm findChildOfClass:@"psti"];
        NSString *url = [name getAttributeNamed:@"href"];
        HTMLNode *time = [[cm findChildOfClass:@"xg1"] findChildTag:@"span"];
        NSDictionary *cmDic = [NSDictionary dictionaryWithObjectsAndKeys:[name contents],@"name",[context contents],@"ontext",[time contents],@"time",url,@"url",nil];
        [cmListArr addObject:cmDic];
    }
    return cmListArr;
}

//解析帖子信息
-(ForumTopicModel *)parsePostMsg:(HTMLNode *)postNode{
    
    ForumTopicModel *topic = [[ForumTopicModel alloc] init];
    
    if ([postNode findChildOfClass:@"hm ptn"]) {
        NSArray *m = [[postNode findChildOfClass:@"hm ptn"] findChildrenOfClass:@"xi1"];
        topic.t_replyNum = [m[0] allContents];;
        topic.t_scanNum= [m[1] allContents];;
        topic.t_Name = [[[postNode findChildOfClass:@"plc ptm pbn vwthd"] findChildOfClass:@"ts"] allContents];
        topic.t_Id = [[[[postNode findChildOfClass:@"xg1"] findChildTag:@"a"] getAttributeNamed:@"href"] requireFristInt];
    }else if([postNode findChildOfClass:@"cl"]){
        
    }
    return topic;
    
}

//解析楼层用户资料
-(Briefuser *)parseUser:(HTMLNode *)userNode{
    
    Briefuser *breifuser = [[Briefuser alloc] init];
    
    NSArray *m = [[userNode findChildOfClass:@"cl"] findChildTags:@"dd"];
    
    breifuser.img = [[[userNode findChildOfClass:@"avtm"] findChildTag:@"img"] getAttributeNamed:@"src"];
    breifuser.name = [[[userNode findChildOfClass:@"i y"] findChildTag:@"a"] allContents];
    
    breifuser.sex = [m[0] allContents];
    breifuser.uid = [m[1] allContents];
    breifuser.topic = [m[2] allContents];
    breifuser.postNum = [m[3] allContents];
    breifuser.score = [m[4] allContents];
    breifuser.registerTime = [m[5] allContents];
    breifuser.inlineTime = [m[6] allContents];
    breifuser.lastSignTime = [m[7] allContents];
    
    NSArray *mm = [[userNode findChildOfClass:@"pil cl"] findChildTags:@"dd"];
    breifuser.score = [mm[0] allContents];
    breifuser.money = [mm[1] allContents];
    breifuser.upload = [mm[2] allContents];
    breifuser.download = [mm[3] allContents];
    breifuser.torrent = [mm[4] allContents];
    breifuser.counter = [mm[5] allContents];
    breifuser.protection = [mm[6] allContents];
    breifuser.character = [mm[7] allContents];
    
    NSArray *mmm = [[userNode findChildOfClass:@"tns xg2"] findChildTags:@"a"];
    breifuser.topic = [mmm[0] allContents];
    breifuser.postNum = [mmm[1] allContents];
    breifuser.score = [mmm[2] allContents];
    
    return breifuser;
    
}

-(void)HTMLParseContent:(NSString *)content{
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
    if (error) [self ReportError:error];
    
    HTMLNode *bodyNode = [parser body] ;
    
    BOOL isLogin = [super HTMLParseLoginState:bodyNode];
    
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"postlist" allowPartial:NO];
    ForumTopicModel *topic = [self parsePostMsg:[postNode findChildTag:@"table"]];

    HTMLNode * pl_topNode = [postNode findChildWithAttribute:@"id" matchingName:@"pl_top" allowPartial:NO];
    if (pl_topNode) { //有金币信息
        topic.t_award = [[pl_topNode findChildOfClass:@"pls vm ptm"] allContents];
        topic.t_awardDetails = [[pl_topNode findChildOfClass:@"plc ptm pbm xi1"] allContents];
    }
    
    NSMutableArray<Floor*> *floors = [NSMutableArray arrayWithCapacity:10];
    NSArray *postNodes = [bodyNode findChildrenOfClass:@"plhin"];
    for (HTMLNode *postNode in postNodes) {
        
        Floor *floor = [[Floor alloc] init];
        
        HTMLNode  *authi = [postNode findChildOfClass:@"authi"];
        NSArray *As = [authi findChildTags:@"a"];
        floor.username = [As[0] allContents];
        floor.userId = [[authi findChildWithAttribute:@"rel" matchingName:@"nofollow" allowPartial:NO] getAttributeNamed:@"href"];
        HTMLNode *em = [authi findChildTag:@"em"];
        floor.time = [[em findChildTag:@"span"] allContents];
        
       // HTMLNode *pi = [postNode findChildOfClass:@"pi"];
       // floor.floorNum = [[pi findChildTag:@"span"] allContents];
        
        HTMLNode *plc = [postNode findChildOfClass:@"t_fsz"];
        HTMLNode *quoteNode = [plc findChildOfClass:@"quote"];
        if (quoteNode) {
            floor.quote = [quoteNode allContents];
        }
        floor.body = [@"" clearRN:[[plc findChildOfClass:@"t_f"] allContents]];
        
        floor.user = nil;
        if (isLogin) {
            HTMLNode *userNode = [postNode findChildOfClass:@"pls"];
            floor.user = [self parseUser:userNode];
        }
        
        HTMLNode *cm = [postNode findChildOfClass:@"cm"];
        floor.comments =  cm ?[self parseComment:cm] : [NSMutableArray array];
        
       // HTMLNode *rate = [postNode findChildOfClass:@"rate"];
       // floor.rates =  cm ?[self parseRate:rate] : [NSMutableArray array];
        
        [floors addObject:floor];
        
    }
    self.floors = floors;
    
    HTMLNode *pageRootNode = [[[bodyNode findChildOfClass:@"pgs mtm mbm cl"] findChildOfClass:@"pg"] findChildTag:@"label"];
    topic.t_currentPage = [[[pageRootNode findChildTag:@"input"] getAttributeNamed:@"value"] integerValue];
    topic.t_maxPage = [[[pageRootNode findChildTag:@"span"] allContents] requireFristInt];
    
    _topic = topic;
    
}

-(void)ReportError:(NSError *)error{
   
}
@end
