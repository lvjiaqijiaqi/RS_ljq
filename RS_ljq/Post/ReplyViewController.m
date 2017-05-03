//
//  ReplyViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/2.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "ReplyViewController.h"

@interface ReplyViewController ()<UITextViewDelegate>

@property NSInteger tid; //帖子
@property NSInteger fid; //板块

@property(nonatomic,strong) UITextView *replyTextView;

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.editable = YES;
    textView.bounces = NO;
    textView.bouncesZoom = NO;
    textView.alwaysBounceHorizontal = NO;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textView.delegate = self;
    [self.view addSubview:textView];
    [textView becomeFirstResponder];
    _replyTextView = textView;
    
}


-(NSDictionary *)ReplyStrAttribute{
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 10;
    //段落间距
    paragraph.paragraphSpacing = 20;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    paragraph.headIndent = 10;
    
    NSDictionary *dictAttr = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] , NSParagraphStyleAttributeName : paragraph};
    return [dictAttr copy];
    
}

-(void)textViewDidChange:(UITextView *)textView{
        NSLog(@"%f",[self heightForString]);
}

-(float)heightForString{
    CGSize sizeToFit = [self.replyTextView.text boundingRectWithSize:CGSizeMake(self.replyTextView.frame.size.width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:[self ReplyStrAttribute]        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

@end
