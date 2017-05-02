//
//  IndexTableViewDelegate.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "IndexTableViewDelegate.h"
#import "IndexParse.h"
#import "IndexTopicRandingModel.h"
#import "PostTableViewCell.h"
#import "ImageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IndexImageModel.h"

@interface IndexTableViewDelegate()

@property(nonatomic,strong) void(^completeHandle)(NSInteger tid ,NSString *str);

@end

@implementation IndexTableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

-(void)setSelectHandle:(void (^)(NSInteger tid ,NSString *str))completeHandle{
    _completeHandle = [completeHandle copy];
}
/*
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_new;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_newReply;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_recommend;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_weekHot;
@property(nonatomic,strong)  NSArray<IndexTopicRandingModel *> *topicLis_dayHot;
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self databyIndex:tableView.tag].count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        IndexImageModel *model = (IndexImageModel *)[[self databyIndex:tableView.tag] objectAtIndex:indexPath.row];
        [cell.ImageV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"ym1"]];
        cell.detailLabel.text = model.imageTitle;
        
        return cell;
    }
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    IndexTopicRandingModel *model = (IndexTopicRandingModel *)[[self databyIndex:tableView.tag] objectAtIndex:indexPath.row];
    
    cell.PostNameLabel.text = model.topicName;
    cell.PostNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.subMsg.text = model.topicAddition;
    cell.PostNameLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tid = 0;
    NSString *Tname =@"";
    if (tableView.tag == 0) {
        IndexImageModel *model = (IndexImageModel *)[[self databyIndex:tableView.tag] objectAtIndex:indexPath.row];
        tid = model.topicId;
        Tname = model.imageTitle;
    }else{
        IndexTopicRandingModel *model = (IndexTopicRandingModel *)[[self databyIndex:tableView.tag] objectAtIndex:indexPath.row];
        tid = model.topicId;
        Tname = model.topicName;
    }
    self.completeHandle(tid,Tname);
}

-(NSArray *)databyIndex:(NSInteger)section{
    switch (section) {
        case 0:
            return self.indexParse.topicLis_imgHot;
            break;
        case 1:
            return self.indexParse.topicLis_new;
            break;
        case 2:
            return self.indexParse.topicLis_newReply;
            break;
        case 3:
            return self.indexParse.topicLis_recommend;
            break;
        case 4:
            return self.indexParse.topicLis_weekHot;
            break;
        case 5:
            return self.indexParse.topicLis_dayHot;
            break;
        default:
            break;
    }
    return nil;
}

@end
