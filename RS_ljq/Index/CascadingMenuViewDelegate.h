//
//  CascadingMenuViewDelegate.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CascadingMenuView.h"
@class IndexParse;

@interface CascadingMenuViewDelegate : NSObject<CascadingMenuViewDataSource>
@property (weak,nonatomic) IndexParse *indexParse;
-(void)setSelectOperationBlock:(void (^)(NSInteger zid))selectOperationBlock;
@end
