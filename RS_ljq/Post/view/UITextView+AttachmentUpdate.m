//
//  UITextView+AttachmentUpdate.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/10.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "UITextView+AttachmentUpdate.h"
#import <UIView+WebCacheOperation.h>
#import "objc/runtime.h"

static char attachmentLocsKey;

@implementation UITextView (AttachmentUpdate)

- (NSArray<NSDictionary *> *)attachmentLocsArray {
    NSArray<NSDictionary *> *attachmentLocs = objc_getAssociatedObject(self, &attachmentLocsKey);
    if (attachmentLocs) {
        return attachmentLocs;
    }
    return nil;
}

-(void)setAttachmentLocsArray:(NSArray *)attachmentLocsArray{
    objc_setAssociatedObject(self, &attachmentLocsKey, attachmentLocsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)repareAttachment:(NSArray<NSDictionary *>*)locsArray{
    [locsArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger loc = [[obj objectForKey:@"loc"] integerValue];
        NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        attach.bounds = CGRectMake(0, 0, 30,30);
        [self.textStorage replaceCharactersInRange:NSMakeRange(loc, 1) withAttributedString:strAtt];
    }];
}
-(void)updateAttachment:(NSArray<NSDictionary *>*)locsArray{
    
    [self sd_cancelCurrentAnimationImagesLoad];
    
    __weak __typeof(self)wself = self;
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    [locsArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *src = [NSURL URLWithString:[obj objectForKey:@"src"]];
        NSInteger loc = [[obj objectForKey:@"loc"] integerValue];
        if (src) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:src options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{//更新attachment
                if (image) {
                if (!wself) return; //有必要时候还可以加一个判断
                    NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
                    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
                    attach.bounds = CGRectMake(0, 0, 30,30);
                    attach.image = image;
                    //[self.textStorage replaceCharactersInRange:NSMakeRange(loc, 1) withAttributedString:strAtt];
                    }
                });
            }];
            [operationsArray addObject:operation];
        }
    }];
    
    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
    
}
- (void)sd_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

@end
