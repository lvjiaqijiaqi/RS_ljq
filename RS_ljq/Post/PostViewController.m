//
//  PostViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/24.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "PostViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RsNetworking.h"
#import "ForumParse.h"
#import "LoginWorking.h"
#import "FloorTVRefreshHeader.h"
#import "RS_attributeStringFactory.h"
#import "NSString+DataToString.h"
#import "UINavigationBar+Awesome.h"

#import "Post.h"
#import "Floor.h"
#import "BriefUser.h"
#import "MJRefreshBackNormalFooter.h"

#import "FloorTableViewCell.h"
#import "PostHeaderView.h"

@interface PostViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *postTableView;
@property(nonatomic,strong) PostHeaderView *postHeaderView;

@property(nonatomic,strong) NSMutableArray<Floor *> *floors;
@property(nonatomic,strong) Post *post;

//
@property(nonatomic,assign) NSInteger currentPage; //
@property(nonatomic,assign) NSInteger authorid;  //
@property(nonatomic,assign) NSInteger order; //1正序 2倒叙
@end

@implementation PostViewController

- (instancetype)initWithPostModel:(Post*)model
{
    self = [super init];
    if (self) {
        _post = model;
        _floors = [NSMutableArray array];
    }
    return self;
}

-(PostHeaderView *)postHeaderView{
    if (!_postHeaderView) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"PostHeaderView" owner:nil options:nil];
        PostHeaderView *postHeaderView = [nibContents lastObject];
        
        //titleLabel计算高度
        NSDictionary *dictAttr = [RS_attributeStringFactory PostHeaderLabelAttribute];
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGFloat height = [self.post.name boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) options:options attributes:dictAttr context:nil].size.height;
        height = ceil(height+91);
        
        //初始化帖子信息
        postHeaderView.titleLabel.attributedText =  [[NSAttributedString alloc] initWithString:[@"" clearRN:self.post.name]  attributes:dictAttr];
        postHeaderView.sacnLabel.text = self.post.scan;
        postHeaderView.replyLabel.text = self.post.reply;
        postHeaderView.moneyLabel.text = @"";
        
        [postHeaderView setFrame:CGRectMake(0, -height, self.view.frame.size.width, height)];
        //postHeaderView.backgroundColor = [UIColor redColor];
        _postHeaderView = postHeaderView;
        
    }
    return _postHeaderView;
}


-(void)parePareCom{
    
    UITableView *tV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    [tV registerNib:[UINib nibWithNibName:@"CellView" bundle:nil] forCellReuseIdentifier:@"FloorCell"];
    tV.delegate = self;
    tV.dataSource = self;
    _postTableView = tV;
    
    [_postTableView addSubview:self.postHeaderView];
    [_postTableView setContentInset:UIEdgeInsetsMake(self.postHeaderView.frame.size.height, 0, 0, 0)];
    [self.view addSubview:_postTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
    
    [self parePareCom];
    
    //下拉刷新设置
    __weak typeof(self) weakSelf = self;
    FloorTVRefreshHeader *header =  [[FloorTVRefreshHeader alloc] init];
    header.ignoredScrollViewContentInsetTop = _postTableView.contentInset.top;
    [header setRefreshingBlock:^{
        [RsNetworking PostWithFid:self.post.pid Page:1 Authorid:0 Order:1 completionHandler:^(NSString *str) {
            ForumParse *forumParse =  [[ForumParse alloc] init] ;
            [forumParse HTMLParseContent:str];
            [weakSelf updateDataSource:forumParse appendData:NO];
            weakSelf.currentPage = 1;
            [weakSelf.postTableView.mj_header endRefreshing];
        }];
    }];
    _postTableView.mj_header = header;
    
    //上啦加载设置
    _postTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSInteger nextPage = 1 + weakSelf.currentPage > weakSelf.post.maxPage ? 0 : 1 + weakSelf.currentPage;
        if (nextPage < 1){
            [weakSelf.postTableView.mj_footer endRefreshing];
            return;
        }
        [RsNetworking PostWithFid:self.post.pid Page:nextPage Authorid:0 Order:1 completionHandler:^(NSString *str) {
            ForumParse *forumParse =  [[ForumParse alloc] init] ;
            [forumParse HTMLParseContent:str];
            [weakSelf updateDataSource:forumParse appendData:YES];
            weakSelf.currentPage++;
            [weakSelf.postTableView.mj_footer endRefreshing];
        }];
    }];

}

-(void)viewDidAppear:(BOOL)animated{
    [self.postTableView.mj_header beginRefreshing];
}


-(void)updateDataSource:(ForumParse*)forumParse appendData:(BOOL)isAppend{
    if (isAppend) {
    }else{
        @synchronized (self) {
            [self.floors removeAllObjects];
        }
    }
    [self.post updateModel:forumParse.post];
    @synchronized (self) {
        [self.floors addObjectsFromArray:forumParse.floors];
    }
    [self.postTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma  -mark- tableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.floors count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FloorCell"];
    Floor *f = [self.floors objectAtIndex:indexPath.row];
    cell.uNameLabel.text = f.username;
    
    cell.bodyTextView.attributedText = [[NSAttributedString alloc] initWithString:[@"" clearRN:f.body] attributes:[RS_attributeStringFactory FloorLabelAttribute]];
    
    cell.floorNumLabel.text = f.floorNum;
    cell.publishTimeLabel.text = f.time;
    if (f.user && f.user.img) {
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:f.user.img] placeholderImage:nil];
    }
    return cell;
}

#pragma  -mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Floor *f = [self.floors objectAtIndex:indexPath.row];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat height = [f.body boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) options:options attributes:[RS_attributeStringFactory FloorLabelAttribute] context:nil].size.height;
    return ceil(height) + 1 + 110;
}
@end
