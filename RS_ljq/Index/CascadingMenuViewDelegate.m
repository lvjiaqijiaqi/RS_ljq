//
//  CascadingMenuViewDelegate.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "CascadingMenuViewDelegate.h"
#import "IndexParse.h"

#include "CornerModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface CascadingMenuViewDelegate()

@property (strong,nonatomic) void(^selectOperationBlock)(NSInteger zid);

@end

@implementation CascadingMenuViewDelegate

-(void)setSelectOperationBlock:(void (^)(NSInteger zid))selectOperationBlock{
        _selectOperationBlock = [selectOperationBlock copy];
}

-(NSArray *)MenusInCascadingMenuViewDataSource:(CascadingMenuView *)cascadingMenuView{
    return [self.indexParse.zoneLists allKeys];
}
-(UITableViewCell *)embellishCell:(UITableViewCell *)tableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CornerModel *model = [[[self.indexParse.zoneLists allValues] objectAtIndex:section] objectAtIndex:row];
    tableViewCell.textLabel.text = model.c_Name;
    tableViewCell.detailTextLabel.text = [model subsiteContent];
    [tableViewCell.imageView sd_setImageWithURL:[NSURL URLWithString:model.c_Img] placeholderImage:[UIImage imageNamed:@"ym"]];
    return tableViewCell;
}

-(NSInteger)tableView:(CascadingMenuView *)cascadingMenuView numberOfRowsInSection:(NSInteger)section{
    return [[self.indexParse.zoneLists allValues] objectAtIndex:section].count;
}

-(void)tableView:(CascadingMenuView *)cascadingMenuView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CornerModel *model = [[[self.indexParse.zoneLists allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.selectOperationBlock(model.c_Id);
}
@end
