//
//  Index.h
//  rs
//
//  Created by lvjiaqi on 16/6/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Index : NSObject

@property(strong,nonatomic) NSMutableArray *indexPosts;
@property(strong,nonatomic) NSMutableArray *userInRating;
@property(strong,nonatomic) NSMutableArray *indexParts;
@property(strong,nonatomic) NSMutableArray<NSString *> *indexPartsName;

- (instancetype)initWithData:(NSData *)data;
@end
