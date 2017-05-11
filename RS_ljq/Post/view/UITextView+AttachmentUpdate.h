//
//  UITextView+AttachmentUpdate.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AttachmentUpdate)

-(void)updateAttachment:(NSArray<NSDictionary * >*)locsArray;
-(void)repareAttachment:(NSArray<NSDictionary *>*)locsArray;

@end
