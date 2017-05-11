//
//  PostImgTableViewCell.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/8.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "PostImgTableViewCell.h"
#import <SDWebImageManager.h>
#import <SDImageCache.h>

@implementation PostImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _oriW = 300;
    _oriH = 150;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setImageUrl:(NSString *)imageUrl completeHandle:(void(^)(UIImage *img, NSString *imgUrl,BOOL needRefrash))completeBlock{
    if (imageUrl) {
        _imageUrl = imageUrl;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        // 没有缓存图片
        if (!cachedImage) {
            __weak typeof(self) target = self;
            // 利用 SDWebImage 框架提供的功能下载图片
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                // 保存图片
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES]; // 保存到磁盘
                if (imageUrl == target.imageUrl) {
                     //[target configPreviewImageViewWithImage:image];
                     completeBlock(image,imageUrl,YES);
                }
               
            }];
        }else
        {
            [self configPreviewImageViewWithImage:cachedImage];
            completeBlock(cachedImage,imageUrl,NO);
        }
        
    }
}

- (void)configPreviewImageViewWithImage:(UIImage *)image
{
    dispatch_main_async_safe(^{
        self.imgView.image = image;
        [self.imgView setNeedsDisplay];
    });
}

-(void)updateConstraints{
    if (!self.heightCon.constant > 10000.f) {
        self.heightCon.constant = 200;
    }
    [super updateConstraints];
}
@end
