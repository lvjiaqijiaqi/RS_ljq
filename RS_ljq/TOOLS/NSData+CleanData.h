//
//  NSData+CleanData.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/24.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CleanData)
-(NSData *)cleanUTF8;
-(NSData *)UTF8Data;
- (NSData *)replaceNoUtf8:(NSData *)data;
@end
