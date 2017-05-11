//
//  FloorViewModel.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/7.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorViewModel.h"
#import "RS_attributeStringFactory.h"
#import "SDWebImageManager.h"
#import "NSString+DataToString.h"

#import "FloorBodyVM.h"
#import "FloorImageVM.h"
#import "FloorQuoteVM.h"
#import "FloorPstatusVM.h"

#import "Comment.h"
#import "Floor.h"

@implementation FloorViewModel

-(instancetype)initWithModel:(Floor *)model
{
    self = [super init];
    if (self) {
        NSMutableArray *cellVM =  [NSMutableArray array];
        __block NSInteger offset = 0;
        
        if (model.pstatus) {
            FloorPstatusVM *bVM = [[FloorPstatusVM alloc] init];
            bVM.attributeStr = [[NSAttributedString alloc] initWithString:model.pstatus attributes:[RS_attributeStringFactory postPstatusAttribute]];
            [cellVM addObject:bVM];
        }
        if (model.quote) {
            FloorQuoteVM *bVM = [[FloorQuoteVM alloc] init];
            bVM.attributeStr = [[NSAttributedString alloc] initWithString:model.quote attributes:[RS_attributeStringFactory postQuoteAttribute]];
            [cellVM addObject:bVM];
        }
        NSMutableArray *smileLocs =  [NSMutableArray array];
        [model.imgs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj objectForKey:@"location"]) {
                if ([obj objectForKey:@"smilieid"]) {
                    NSInteger modifyLoc = [[obj objectForKey:@"location"] integerValue]-offset;
                    NSString *src = [obj objectForKey:@"src"];
                    [smileLocs addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:modifyLoc],@"loc",src,@"src",nil]];
                }else{ //遇到非表情图片 切割
                    NSInteger nowLoc = [[obj objectForKey:@"location"] integerValue];
                    if (offset != nowLoc) {
                        NSString *newStr = [model.body substringWithRange:NSMakeRange(offset, nowLoc-offset)];
                        if ([NSString clearRN:newStr].length > 0) {
                            FloorBodyVM *bVM = [[FloorBodyVM alloc] init];
                            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithString:newStr] attributes:[RS_attributeStringFactory postBodyAttribute]];
                            bVM.attachments = [NSArray arrayWithArray:smileLocs];
                            bVM.body =  [NSString stringWithString:newStr];
                            [smileLocs enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSInteger loc = [[obj objectForKey:@"loc"] integerValue];
                                NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
                                attach.bounds = CGRectMake(0, 0, 30,30);
                                [attrStr addAttribute:NSAttachmentAttributeName value:attach range:NSMakeRange(loc, 1)];
                            }];
                            
                            bVM.attributeStr = attrStr;
                            [smileLocs removeAllObjects];
                            [cellVM addObject:bVM];
                        }
                    }
                    FloorImageVM *imgVM =  [[FloorImageVM alloc] init];
                    imgVM.src = [obj objectForKey:@"src"];
                    offset = nowLoc+1;
                    [cellVM addObject:imgVM];
                }
            }
        }];
        if (offset < model.body.length) {
            
            FloorBodyVM *bVM = [[FloorBodyVM alloc] init];
            bVM.attachments = [NSArray arrayWithArray:smileLocs];
            NSString *newStr = [NSString stringWithString:[model.body substringFromIndex:offset]];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithString:newStr] attributes:[RS_attributeStringFactory postBodyAttribute]];
            bVM.attachments = [NSArray arrayWithArray:smileLocs];
            bVM.body =  [NSString stringWithString:newStr];
            [smileLocs enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger loc = [[obj objectForKey:@"loc"] integerValue];
                NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
                attach.bounds = CGRectMake(0, 0, 30,30);
                [attrStr addAttribute:NSAttachmentAttributeName value:attach range:NSMakeRange(loc, 1)];
            }];
            
            bVM.attributeStr = attrStr;
            
            [smileLocs removeAllObjects];
            [cellVM addObject:bVM];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc] init];
        [model.comments enumerateObjectsUsingBlock:^(Comment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSAttributedString *uname = [[NSAttributedString alloc] initWithString:obj.username attributes:[RS_attributeStringFactory postCommentUnameAttribute]];
            [commentStr appendAttributedString:uname];
            
            [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  " attributes:[RS_attributeStringFactory postCommentBodyAttribute]]];
            
            NSAttributedString *time = [[NSAttributedString alloc] initWithString:obj.time attributes:[RS_attributeStringFactory postCommentPublicTimeAttribute]];
            [commentStr appendAttributedString:time];
            
            [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:[RS_attributeStringFactory postCommentBodyAttribute]]];
            
            NSAttributedString *body = [[NSAttributedString alloc] initWithString:obj.body attributes:[RS_attributeStringFactory postCommentBodyAttribute]];
            [commentStr appendAttributedString:body];
            
            [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:[RS_attributeStringFactory postCommentBodyAttribute]]];
            
        }];
        if (commentStr.length > 0) {
            FloorBodyVM *CVM = [[FloorBodyVM alloc] init];
            CVM.attributeStr  = commentStr;
            [cellVM addObject:CVM];
        }
        _cellsVm = cellVM;
        _userName = model.username;
        _publishTime = model.time;
        _floorNum = [@"" clearRN:model.floorNum];
        
        _headImg = [NSURL URLWithString:model.user.img];
        
    }
    
    return self;
}

/*
-(NSAttributedString *)repareAttachment:(NSArray<NSDictionary *>*)locsArray{
    [locsArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger loc = [[obj objectForKey:@"loc"] integerValue];
        NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        attach.bounds = CGRectMake(0, 0, 30,30);
        [self.textStorage replaceCharactersInRange:NSMakeRange(loc, 1) withAttributedString:strAtt];
    }];
}
*/


@end


