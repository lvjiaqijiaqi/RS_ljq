//
//  FloorTableViewCell.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/26.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloorTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *uNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *floorNumLabel;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;
@property (strong, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (assign, nonatomic)  NSInteger idx;
-(void)displayImgs:(NSArray<NSDictionary *> *)imgs competeHandle:(void(^)( NSInteger loc,UIImage *image ,FloorTableViewCell *cell))completeHandle;
@end
