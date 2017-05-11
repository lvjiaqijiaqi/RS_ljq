//
//  PostHeaderTableViewCell.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/8.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHeaderTableViewCell : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UIImageView *headerImgView;
@property (strong, nonatomic) IBOutlet UILabel *unameLabel;
@property (strong, nonatomic) IBOutlet UILabel *floorNumLabel;

@end
