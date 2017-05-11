//
//  PostImgTableViewCell.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/8.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostImgTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSString *imageUrl;

@property (assign, nonatomic)  CGFloat oriW;
@property (assign, nonatomic)  CGFloat oriH;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCon;

-(void) setImageUrl:(NSString *)imageUrl completeHandle:(void(^)(UIImage *img, NSString *imgUrl,BOOL needRefrash))completeBlock;


@end
