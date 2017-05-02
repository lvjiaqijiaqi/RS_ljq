//
//  IndexTableViewDelegate.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexParse;

@interface IndexTableViewDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) IndexParse *indexParse;

-(void)setSelectHandle:(void(^)(NSInteger tid ,NSString *str))completeHandle;

@end
