//
//  PostViewController.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/24.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumTopicModel;

@interface PostViewController : UIViewController

- (instancetype)initWithPostModel:(ForumTopicModel*)model;

@end
