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
#import "Comment.h"

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
        Comment *c = [[Comment alloc] init];
        c.body =  [NSString clearRN:[context contents]];
        c.username = [NSString clearRN:[name contents]];
        c.time = [NSString clearRN:[time contents]];
        c.headImg =[NSString clearRN:url] ;
        [cmListArr addObject:c];
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
        topic.t_awardDetails = [NSString stringWithFormat:@"回帖得%ld金币",(long)[[[pl_topNode findChildOfClass:@"plc ptm pbm xi1"] allContents] requireFristInt]];
    }else{
        topic.t_award = @"";
        topic.t_awardDetails = @"";
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
        
        HTMLNode *pi = [[postNode findChildOfClass:@"plc"] findChildOfClass:@"pi"];
        if (pi) {
            floor.floorNum = @"";
            if([pi findChildTag:@"a"]){
                floor.floorNum = [NSString stringWithFormat:@"#%ld",(long)[[[pi findChildTag:@"a"] allContents] requireFristInt]];
            }
        }
        
        HTMLNode *plc = [postNode findChildOfClass:@"t_fsz"];
        HTMLNode *quoteNode = [plc findChildOfClass:@"quote"];
        if (quoteNode) {
            floor.quote =  [quoteNode allContents];
        }
        
        //__block NSMutableString *str = [NSMutableString string];
        NSMutableArray *imgArr =  [NSMutableArray array];
        NSMutableString *str = [NSMutableString string];
        
        //
        if ([[postNode findChildOfClass:@"t_f"] findChildOfClass:@"pstatus"]) {
            floor.pstatus = [[[postNode findChildOfClass:@"t_f"] findChildOfClass:@"pstatus"] allContents];
        }
        
        [self parseBody:[postNode findChildOfClass:@"t_f"] withImgs:imgArr forStr:str];
        floor.body = str;
        floor.imgs = imgArr;
        
        //提取图片
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

-(void)parseBody:(HTMLNode *)bodyNode withImgs:(NSMutableArray *)imgs forStr:(NSMutableString *)str{
    NSArray<HTMLNode *> *childrens = [bodyNode children];
    if (childrens.count == 0) {
        return ;
    }
    __block NSInteger brCount = 0;
    [childrens enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.tagName isEqual: @"br"] && str.length > 0 && ![[str substringFromIndex:str.length-1] isEqualToString:@"\n"]) {
             [str appendString:@"\n"];
        }else{
            if (obj.nodetype == HTMLTextNode) {
                if (![[obj allContents] isEqualToString:@"\n"] && ![[obj allContents] isEqualToString:@"\r\n"]) {
                    [str appendString: [NSString clearMultipleRNS:[@"" clearRN:obj.allContents]]];
                }
            }else{
                brCount = 0;
                if ([obj.tagName  isEqual: @"img"]) {
                    NSDictionary *imgDic = [self pareseImg:obj];
                    if (imgDic) {
                        [imgDic setValue:[NSNumber numberWithInteger:str.length] forKey:@"location"];
                        [str appendString:@"-"];
                        [imgs addObject:imgDic];
                    }
                }else if([obj.tagName  isEqual: @"ignore_js_op"]) {
                    if ([obj findChildTag:@"img"]) {
                        NSArray<HTMLNode *>  *imgNodes = [obj findChildTags:@"img"];
                        [imgNodes enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary *imgDic = [self pareseImg:obj];
                            if (imgDic) {
                                [imgDic setValue:[NSNumber numberWithInteger:str.length] forKey:@"location"];
                                [str appendString:@"-"];
                                [imgs addObject:imgDic];
                            }
                        }];
                    }
                }else{
                    if([obj.tagName isEqual: @"div"] && str.length > 0 && ![[str substringFromIndex:str.length-1] isEqualToString:@"\n"])
                        [str appendString:@"\n"];
                    if ([[obj getAttributeNamed:@"class"] isEqualToString:@"quote"]|| [[obj getAttributeNamed:@"class"] isEqualToString:@"pstatus"]) {
                        return;
                    }
                    [self parseBody:obj withImgs:imgs forStr:str];
                }
            }
        }
    }];
    return ;
}

-(NSDictionary *)pareseImg:(HTMLNode *)imgNode{
        if ([imgNode getAttributeNamed:@"src"] || [imgNode getAttributeNamed:@"file"]) {
            NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:8];
            if([imgNode getAttributeNamed:@"src"]){
                [imgDic setObject:[imgNode getAttributeNamed:@"src"] forKey:@"src"];
            }else{
                [imgDic setObject:[imgNode getAttributeNamed:@"file"] forKey:@"src"];
            }
            if ([imgNode getAttributeNamed:@"width"]) {
                [imgDic setObject:[imgNode getAttributeNamed:@"width"] forKey:@"width"];
            }
            if ([imgNode getAttributeNamed:@"height"]) {
                [imgDic setObject:[imgNode getAttributeNamed:@"height"] forKey:@"height"];
            }
            if ([imgNode getAttributeNamed:@"smilieid"]) {
                [imgDic setObject:[imgNode getAttributeNamed:@"smilieid"] forKey:@"smilieid"];
                [imgDic setObject:[NSString stringWithFormat:@"http://rs.xidian.edu.cn/%@",[imgNode getAttributeNamed:@"src"]] forKey:@"src"];
            }else{
                if ([[imgNode getAttributeNamed:@"src"] containsString:@"common/none"]) {
                    [imgDic setObject:[NSString stringWithFormat:@"http://rs.xidian.edu.cn%@", [[imgNode getAttributeNamed:@"file"] substringFromIndex:1]] forKey:@"src"];
                }
            }
            return imgDic;
        }
    return nil;
}

-(void)ReportError:(NSError *)error{
   
}
@end
