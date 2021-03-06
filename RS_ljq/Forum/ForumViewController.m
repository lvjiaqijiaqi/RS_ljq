//
//  ForumViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/23.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "ForumViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "UINavigationBar+Awesome.h"
#import "RsNetworking.h"

#import "ZoneParse.h"
#import "ForumTopicModel.h"
#import "CornerDetailModel.h"

#import "ForumTableViewCell.h"
#import "HeadView.h"
#import "MJDIYHeader.h"
#import "CategoryView.h"

#import "PostViewController.h"



#define NAVBAR_CHANGE_POINT - 150
#define HEADERHEIGHT 200
#define MENUHEIGHT 40

@interface ForumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *ForumTableView;
@property(nonatomic,strong) NSMutableArray<ForumTopicModel *> *topicList;
@property(nonatomic,strong) HeadView *headView;
@property(nonatomic,strong) CategoryView *cateGoryView;
@end

@implementation ForumViewController

-(UITableView *)ForumTableView{
    if (!_ForumTableView) {
        
        _ForumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _ForumTableView.contentInset = UIEdgeInsetsMake(MENUHEIGHT+HEADERHEIGHT, 0, 0, 0);
        [_ForumTableView registerNib:[UINib nibWithNibName:@"ForumPostCell" bundle:nil] forCellReuseIdentifier:@"PostCell"];
        _ForumTableView.dataSource = self;
        _ForumTableView.delegate = self;
        _ForumTableView.rowHeight = UITableViewAutomaticDimension;
        _ForumTableView.tag = 0;
        _ForumTableView.estimatedRowHeight = 50;
        __weak typeof(self) weakSelf = self;
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil];
        HeadView *h = [nibContents lastObject];
        [h setFrame:CGRectMake(0, -_ForumTableView.contentInset.top, self.view.frame.size.width, HEADERHEIGHT)];
        [self.view addSubview:_ForumTableView];
        [_ForumTableView addSubview:h];
        _headView = h;
        
        CategoryView *categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, -MENUHEIGHT, self.view.frame.size.width, MENUHEIGHT)];
        [categoryView setMaxNumberOfCats:3];
        categoryView.backgroundColor = [UIColor whiteColor];
        NSArray *a = [NSArray arrayWithObjects:@"最新回复",@"最新发布",@"精华",nil];
        [categoryView setCategorys:a withhandling:^(NSInteger selectedId) {
            _ForumTableView.tag = selectedId;
            [weakSelf refreshData:selectedId Page:1];
        }];
        self.cateGoryView = categoryView;
        [self.ForumTableView addSubview:categoryView];
        
        MJDIYHeader *header =  [[MJDIYHeader alloc] init];
        [header setRefreshingBlock:^{
            [weakSelf refreshData:_ForumTableView.tag Page:1];
            [weakSelf.ForumTableView.mj_header endRefreshing];
        }];
        [header setPullingBlock:^(float per){
        }];
        _ForumTableView.mj_header = header;
  
    }
    return _ForumTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topicList = [NSMutableArray array];
    
    [self.ForumTableView.mj_header beginRefreshing];
}

#pragma -mark- custom navigationBar

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.ForumTableView];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.title = @"西电睿思灌水专区";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:0.5];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -(64+MENUHEIGHT+100)) {
        CGFloat alpha = MIN(1, 1 - ( -(64+MENUHEIGHT) - offsetY) / 64);
        
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:(alpha/2+0.5)];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:alpha]}];
        
        if (alpha == 1) {
            CGRect rec = self.cateGoryView.frame;
            rec.origin.y = scrollView.contentOffset.y + 64 ;
            [self.cateGoryView setFrame:rec];
        }else{
             CGRect rec = self.cateGoryView.frame;
             rec.origin.y = -MENUHEIGHT;
             [self.cateGoryView setFrame:rec];
        }
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


-(void)refreshData:(ForumFilter)filter Page:(NSInteger)page{
    
    [RsNetworking forumWithFilter:filter andFid:_fid Page:1 completionHandler:^(NSString *str) {
        ZoneParse *fp = [[ZoneParse alloc] init];
        [fp HTMLParseContent:str];
        [self.topicList removeAllObjects];
        [self.topicList addObjectsFromArray:fp.topicList];
        [self.ForumTableView reloadData];
        self.headView.nameLabel.text = fp.corner.c_Name;
        self.headView.detailsLabel.text = fp.corner.c_Details ;
        self.headView.addtionLabel.text = [fp.corner moderatorsAddition];
        self.headView.backgroundImgView.alpha = 0.75;
        [self.headView.backgroundImgView sd_setImageWithURL:[NSURL URLWithString:fp.corner.c_HeaderImg]];
    }];
}


#pragma -mark- tableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.topicList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    ForumTopicModel *model =  [self.topicList objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.t_Name;
    cell.additonLabel.text = [model subheading];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.scanLabel.text = model.t_scanNum;
    cell.replyLabel.text = model.t_replyNum;
    return cell;
}

#pragma -mark- tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
       ForumTopicModel *model =  [self.topicList objectAtIndex:indexPath.row];
       PostViewController *posVC = [[PostViewController alloc] initWithPostModel:model];
       [self.navigationController pushViewController:posVC animated:YES];
}

@end
