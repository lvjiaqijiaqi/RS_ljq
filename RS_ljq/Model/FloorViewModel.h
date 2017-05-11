//
//  FloorViewModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/7.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Floor;
@class RsTextAttachment;
@class FloorBasicVM;

@interface FloorViewModel : NSObject

@property(nonatomic,assign) NSInteger desId;

@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *publishTime;
@property(nonatomic,strong) NSString *floorNum;
@property(nonatomic,strong) NSURL *headImg;

@property(nonatomic,strong) NSArray<__kindof FloorBasicVM*> *cellsVm;


-(instancetype)initWithModel:(Floor *)model;

@end
