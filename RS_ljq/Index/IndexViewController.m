//
//  ViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/19.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "IndexViewController.h"
#import "ForumParse.h"
#import "ZoneParse.h"
#import "IndexParse.h"
#import "LoginWorking.h"
#import "RsNetworking.h"
#import "CategoryView.h"
#import "IndexTableViewDelegate.h"
#import "ForumViewController.h"

//model
#import "CornerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ForumTopicModel.h"

#import "CascadingMenuView.h"
#import "CascadingMenuViewDelegate.h"
#import "UINavigationBar+Awesome.h"
#import "PostViewController.h"

@interface IndexViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) IndexParse *indexParse;

#pragma 推荐
@property (strong,nonatomic) CascadingMenuView *cascadingMenuView;
@property (strong,nonatomic) CascadingMenuViewDelegate *cascadingMenuViewDelegate;

#pragma 板块
@property (strong,nonatomic) CategoryView *categoryView;
@property (strong,nonatomic) UITableView *indexTableView;
@property (strong,nonatomic) IndexTableViewDelegate* indexTableViewDelegate;

@end

@implementation IndexViewController


#pragma 初始化推荐segment
-(void)initRecommendSegment{
    
    //tableView and tableViewDataSource
    self.indexTableViewDelegate = [[IndexTableViewDelegate alloc] init];
    self.indexTableViewDelegate.indexParse = self.indexParse;
    self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height)];
    self.indexTableView.dataSource = self.indexTableViewDelegate;
    self.indexTableView.delegate = self.indexTableViewDelegate;
    self.indexTableView.estimatedRowHeight = 100;
    self.indexTableView.bounces = NO;
    self.indexTableView.rowHeight=UITableViewAutomaticDimension;
    [self.indexTableView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:@"PostCell"];
    [self.indexTableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"ImageCell"];
    [self.view addSubview:self.indexTableView];
    __weak typeof(self) weakSelf = self;
    [self.indexTableViewDelegate setSelectHandle:^(NSInteger tid ,NSString *str) { //跳转
        ForumTopicModel *model =  [[ForumTopicModel  alloc] init];
        model.t_Name = str;
        model.t_Id = tid;
        PostViewController *posVC = [[PostViewController alloc] initWithPostModel:model];
        [weakSelf.navigationController pushViewController:posVC animated:YES];
    }];
    
    //categoryView
    CategoryView *categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [categoryView setMaxNumberOfCats:3];
    NSArray *a = [NSArray arrayWithObjects:@"最新图文",@"最新主题",@"最新回复",@"主图推荐",@"本周热帖",@"本日热帖",nil];
    [categoryView setCategorys:a withhandling:^(NSInteger selectedId) {
        weakSelf.indexTableViewDelegate.indexParse = weakSelf.indexParse;
        weakSelf.indexTableView.tag = selectedId;
        [weakSelf.indexTableView reloadData];
    }];
    [self.view addSubview:categoryView];
    self.categoryView = categoryView;

}
#pragma 初始化板块segment
-(void)initPlateSegment{
    self.cascadingMenuView = [[CascadingMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.cascadingMenuViewDelegate =  [[CascadingMenuViewDelegate alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.cascadingMenuViewDelegate setSelectOperationBlock:^(NSInteger zid) {
        ForumViewController *fcon =  [[ForumViewController alloc] init];
        fcon.fid = zid;
        [weakSelf.navigationController pushViewController:fcon animated:YES];
    }];
    self.cascadingMenuView.dataSource = self.cascadingMenuViewDelegate;
    [self.view addSubview:self.cascadingMenuView];
    self.cascadingMenuView.hidden = YES;
    [self.cascadingMenuView startWorking];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
    
    [RsNetworking indexWithcompletionHandler:^(NSString *content){
        IndexParse *parse =  [[IndexParse alloc] init];
        [parse HTMLParseContent:content];
        self.indexParse = parse;
        self.indexTableViewDelegate.indexParse = parse;
        self.cascadingMenuViewDelegate.indexParse = parse;
        [self.categoryView selectIndex:0];
        [self.cascadingMenuView updateWorking];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPlateSegment];
    [self initRecommendSegment];
    [self.segmentedControl addTarget:self action:@selector(switchThePage:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchThePage:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            self.cascadingMenuView.hidden = YES;
            self.categoryView.hidden =  NO;
            self.indexTableView.hidden =  NO;
            break;
        case 1:
            self.cascadingMenuView.hidden = NO;
            self.categoryView.hidden =  YES;
            self.indexTableView.hidden =  YES;
            break;
        default:  
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
