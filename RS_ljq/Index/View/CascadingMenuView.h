//
//  CascadingMenuView.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CascadingMenuView;

@protocol CascadingMenuViewDataSource <NSObject>

-(NSArray *)MenusInCascadingMenuViewDataSource:(CascadingMenuView *)cascadingMenuView;
-(NSInteger)tableView:(CascadingMenuView *)cascadingMenuView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)embellishCell:(UITableViewCell *)tableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(CascadingMenuView *)cascadingMenuView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CascadingMenuView : UIView

@property(weak,nonatomic) id<CascadingMenuViewDataSource> dataSource;
@property(assign,nonatomic) NSInteger container;

-(void)startWorking;
-(void)updateWorking;
@end
