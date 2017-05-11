//
//  FloorBodyVM.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorBasicVM.h"

@interface FloorBodyVM : FloorBasicVM

@property(nonatomic,strong) NSString *body;
@property(strong,nonatomic) NSArray<NSDictionary *> *attachments;

@end
