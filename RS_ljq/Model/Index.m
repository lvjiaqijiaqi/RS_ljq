//
//  Index.m
//  rs
//
//  Created by lvjiaqi on 16/6/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "Index.h"
#import "Floor.h"
#import "Post.h"
#import "Part.h"

#import "HTMLNode.h"
#import "HTMLParser.h"

@implementation Index


- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self ParseIndex:data];
    }
    return self;
}


-(void)ParseIndex:(NSData *)data{
    
      NSError *error = nil;
      HTMLParser *parser = [[HTMLParser alloc] initWithData:data error:&error];
      HTMLNode *bodyNode = [parser body];


      HTMLNode *headerPost = [bodyNode findChildWithAttribute:@"id" matchingName:@"frameY27D3B" allowPartial:NO];
      self.indexPosts = [self parseHeaderPost:headerPost];
    
      HTMLNode *todayTating = [bodyNode findChildWithAttribute:@"id" matchingName:@"frameQiMiMI" allowPartial:NO];
      self.userInRating = [self parseTodayRating:todayTating];
    
      HTMLNode *zoneNode = [bodyNode findChildOfClass:@"fl bm"];
      self.indexParts = [self parseParts:zoneNode];
    
    
}


-(NSMutableArray *)parseParts:(HTMLNode *)partNode{
    
    
    NSArray *partArr = [partNode findChildrenOfClass:@"bm bmw  flg cl"];
    NSMutableArray *parts = [NSMutableArray arrayWithCapacity:partArr.count];
    self.indexPartsName = [NSMutableArray arrayWithCapacity:partArr.count];
    
    for (HTMLNode *part in partArr) {
        
        HTMLNode * partTitleNode = [[part findChildOfClass:@"bm_h cl"] findChildTag:@"h2"];
        [self.indexPartsName addObject:[partTitleNode allContents]];
        
        NSArray *eles = [part findChildrenOfClass:@"fl_g"];
        NSMutableArray *eleArr = [NSMutableArray arrayWithCapacity:eles.count];
        
        for (HTMLNode *ele in eles) {
            Part *part = [[Part alloc] init];
            part.img = [[ele findChildTag:@"img"] getAttributeNamed:@"src"];
            
            part.name = [[ele findChildTag:@"dt"] allContents];
            part.pid = [[[ele findChildTag:@"dt"] findChildTag:@"a"] getAttributeNamed:@"href"];
            
            NSArray *dds = [ele findChildTags:@"dd"];
            NSArray *ems = [dds[0] findChildTags:@"em"];
            
            part.topic = [ems[0] allContents];
            part.topicsNum = [ems[1] allContents];
            
            part.lastActive = [dds[1] allContents];
            
           [eleArr addObject:part];
        }
        
        [parts addObject:eleArr];
    }
    
    return parts;
}

-(NSMutableArray *)parseTodayRating:(HTMLNode *)HeaderNode{
    
    HTMLNode *rateNode = [HeaderNode findChildOfClass:@"module cl ml mls"];
    NSArray *lis = [rateNode findChildTags:@"li"];
    
    NSMutableArray *usersInRating = [NSMutableArray arrayWithCapacity:lis.count];
    
    for(HTMLNode * li in lis){
        NSMutableArray *userInRate = [NSMutableArray arrayWithCapacity:4]; // uid img name num
        
        HTMLNode * as = [li findChildTag:@"a"];
        [userInRate addObject:[as getAttributeNamed:@"href"]];
        [userInRate addObject:[[as findChildTag:@"img"] getAttributeNamed:@"src"]];
        
        NSArray * ps = [li findChildTags:@"p"];
        [userInRate addObject:[ps[0] allContents]];
        [userInRate addObject:[ps[1] allContents]];
        
        [usersInRating addObject:userInRate];
    }
    
    return usersInRating;
}

-(NSMutableArray *)parseHeaderPost:(HTMLNode *)HeaderNode{
    
    NSArray *headers = [HeaderNode findChildrenOfClass:@"module cl xl xl1"];
    NSMutableArray *headersArr = [NSMutableArray arrayWithCapacity:headers.count];
    for(HTMLNode *header in headers){
        
        NSArray *Lis = [header findChildTags:@"li"];;
        NSMutableArray<Post*> *lisArr = [NSMutableArray array];
        
        for (HTMLNode *li in Lis) {
            
            Post *post = [[Post alloc] init];
            NSArray *as = [li findChildTags:@"a"];
            post.name = [as[0] allContents];
            
            if(as.count > 1){
                post.userName = [as[1] allContents];
            }else{
                post.lastReplyTime = [[li findChildTag:@"em"] allContents];
            }
            
            [lisArr addObject:post];
            
        }
        
        [headersArr addObject:lisArr];
    }
    
    return headersArr;
}



@end
