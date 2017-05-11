//
//  FloorBasicVM.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VMType) {
    VMTypeBody,
    VMTypeQuote,
    VMTypeImage,
    VMTypePstatus,
};

@interface FloorBasicVM : NSObject
@property(nonatomic,assign) VMType type;
@property(nonatomic,strong) NSAttributedString *attributeStr;
@property(nonatomic,assign)  float height;

-(NSString *)body;
-(NSString *)src;
//NSArray<NSDictionary *> *attachments
-(NSArray<NSDictionary *> *)attachments;
@end
