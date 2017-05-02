//
//  CategoryView.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIScrollView

-(void)setCategorys:(NSArray *)categorys withhandling:(void (^)(NSInteger selectedId))selectedHandler;
-(void)setMaxNumberOfCats:(NSInteger)maxNumberOfCats;

-(void)selectIndex:(NSInteger)selectedHandler;

@end
