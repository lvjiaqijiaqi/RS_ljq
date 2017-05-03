//
//  ProfileHeaderView.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) IBOutlet UITextView *signatureLabel;

@end
