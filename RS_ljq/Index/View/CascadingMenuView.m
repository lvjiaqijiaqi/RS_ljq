//
//  CascadingMenuView.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/21.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "CascadingMenuView.h"

#define menuViewWidth 100
#define menuViewheght 50

#define kColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
                 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//! 参数格式为：222,222,222

//#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]

@interface CascadingMenuView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *menuTableView;
@property(nonatomic,strong) UIScrollView *menuView;
@property(nonatomic,strong) NSArray<UILabel *> *menuSegViews;
@end

@implementation CascadingMenuView


-(CGFloat)frameWidth{
    return self.frame.size.width;
}
-(CGFloat)frameHeight{
    return self.frame.size.height;
    
}

-(UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake([self returnMenuViewWidth], 0, self.frameWidth-[self returnMenuViewWidth], self.frameHeight)];
        _menuTableView.bounces = NO;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        //[_menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _menuTableView;
}

-(void)startWorking{
    [self addSubview:self.menuTableView];
    _container = 0;
}
-(void)updateWorking{
    [self componentMenu];
    [self switchMenuOfContainers:_container];
}


-(CGFloat)returnMenuViewWidth{
    return 120;
}
-(CGFloat)returnMenuViewHeight{
    return 50;
}

-(UIColor*)unFocusColor{
    return [UIColor grayColor];
}
-(UIColor*)focusColor{
    return [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
}

-(UIColor*)menuBackgroundColor{
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
}

-(CGFloat)returnTableViewCellHeight{
    return 80;
}


-(void)componentMenu{
    
    NSArray *menus = [self.dataSource MenusInCascadingMenuViewDataSource:self];
    NSInteger menuNum =  menus.count;
    
    UIScrollView *menuView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self returnMenuViewWidth], self.frameHeight)];
    menuView.contentSize = CGSizeMake(menuViewWidth, menuNum*menuViewheght);
    menuView.backgroundColor = [self menuBackgroundColor];
    
    NSMutableArray *menuSegViews = [NSMutableArray arrayWithCapacity:menuNum];
    [menus enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0, [self returnMenuViewHeight]*idx, [self returnMenuViewWidth], [self returnMenuViewHeight])];
        v.font = [UIFont systemFontOfSize:14];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.firstLineHeadIndent = 10;
        v.attributedText = [[NSAttributedString alloc] initWithString:obj attributes:@{NSParagraphStyleAttributeName : style}];
        v.textColor = [self unFocusColor];
        
        v.backgroundColor = [UIColor clearColor];
        [menuSegViews addObject:v];
        [menuView addSubview:v];
    }];
    _menuSegViews = menuSegViews;
    _menuView = menuView;
    
    UITapGestureRecognizer *chooseContainerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitch:)];
    [_menuView addGestureRecognizer:chooseContainerTapGestureRecognizer];
    
    [self addSubview:_menuView];
    
}


-(void)handleSwitch:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
       NSInteger containerId  = [sender locationInView:_menuView].y/[self returnMenuViewHeight];
       [self switchMenuOfContainers:containerId];
    }
}

-(void)switchMenuOfContainers:(NSInteger)container{
    if (container > self.menuSegViews.count) return;
    self.menuSegViews[self.container].backgroundColor = [UIColor clearColor];
    self.menuSegViews[self.container].textColor = [self unFocusColor];
    self.container = container;
    self.menuSegViews[self.container].backgroundColor = [UIColor whiteColor];
    self.menuSegViews[self.container].textColor = [self focusColor];
    [self.menuTableView reloadData];
}



#pragma tableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource tableView:self numberOfRowsInSection:self.container];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return [self.dataSource embellishCell:cell cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.container]];
    
}

#pragma tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self returnTableViewCellHeight];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.container]];
}

@end
