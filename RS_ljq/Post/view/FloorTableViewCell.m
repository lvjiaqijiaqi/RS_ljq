//
//  FloorTableViewCell.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/26.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "FloorTableViewCell.h"

#import "SDWebImageManager.h"

@implementation FloorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize)
-(void)displayImgs:(NSArray<NSDictionary *> *)imgs competeHandle:(void(^)( NSInteger loc,UIImage *image,FloorTableViewCell *cell))completeHandle{
    [imgs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger loc = [[obj objectForKey:@"location"] integerValue];
            CGFloat width = [[obj objectForKey:@"width"] floatValue];
            CGFloat height = [[obj objectForKey:@"height"] floatValue];
            NSString *url = [obj objectForKey:@"src"];
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         completeHandle(loc,image,weakSelf);
                    });
                }];
            });
     }];
}
@end
