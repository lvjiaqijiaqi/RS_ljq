//
//  PostViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/4/24.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "PostViewController.h"

#import <SDWebImageManager.h>
#import <SDImageCache.h>

#import "RsNetworking.h"
#import "ForumParse.h"
#import "LoginWorking.h"
#import "FloorTVRefreshHeader.h"
#import "RS_attributeStringFactory.h"
#import "NSString+DataToString.h"
#import "UINavigationBar+Awesome.h"

#import "ForumTopicModel.h"
#import "Floor.h"
#import "BriefUser.h"

#import "FloorViewModel.h"
#import "FloorBasicVM.h"

#import "FloorTableViewCell.h"
#import "PostHeaderView.h"
#import "ReplyViewController.h"

#import "MJRefreshBackNormalFooter.h"
#import "UIImageView+WebCache.h"
#import "PostImgTableViewCell.h"
#import "PostBodyTableViewCell.h"
#import "PostHeaderTableViewCell.h"
#import "PostTableViewFooterView.h"
#import "UITextView+AttachmentUpdate.h"

#define toolBarHeight 49

@interface PostViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *postTableView;
@property(nonatomic,strong) PostHeaderView *postHeaderView;
@property(nonatomic,strong) UIToolbar *postToolBar;

@property(nonatomic,strong) NSMutableArray<FloorViewModel *> *floors;
@property(nonatomic,strong) ForumTopicModel *topic;

@property(nonatomic,assign) NSInteger topicId;

@property(nonatomic,strong) NSCache *imgCache;

//
@property(nonatomic,assign) NSInteger currentPage; //
@property(nonatomic,assign) NSInteger authorid;  //
@property(nonatomic,assign) NSInteger order; //1正序 2倒叙
@end

#define UIColorFromRGB1(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation PostViewController

- (instancetype)initWithPostModel:(ForumTopicModel*)model
{
    self = [super init];
    if (self) {
        _topic = model;
        _topicId = model.t_Id;
        _order = 1;
        _floors = [NSMutableArray array];
        _imgCache = [[NSCache alloc] init];
        _imgCache.countLimit = 20;
    }
    return self;
}

#pragma -mark toolBarControll

-(void)postReply:(id)sender {
    NSLog(@"reply");
}
-(void)postBrush:(id)sender {
    NSLog(@"Brush");
}
-(void)postOrder:(id)sender {
    _order = _order == 1? 2 : 1;
    UIButton *btn = sender;
    NSString *sr = _order==1?@"正序浏览":@"倒序浏览";
    [btn setTitle:sr forState:UIControlStateNormal];
    [self.postTableView.mj_header beginRefreshing];
}

-(UIToolbar *)postToolBar{
    
    if (!_postToolBar) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-toolBarHeight, self.view.frame.size.width, toolBarHeight)];
        
        UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        replyBtn.frame=CGRectMake(0, 0, self.view.frame.size.width/4, toolBarHeight);
        UIImage *imageForReplyButton = [UIImage imageNamed:@"send"];
        [replyBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
        [replyBtn setImage:imageForReplyButton forState:UIControlStateNormal];
        NSString *replyBtnStr = @"回复";
        [replyBtn setTitle:replyBtnStr forState:UIControlStateNormal];
        replyBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        //707070
        [replyBtn setTitleColor:UIColorFromRGB(0x707070) forState:UIControlStateNormal];
        UIBarButtonItem *replyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:replyBtn];
        [replyBtn addTarget:self action:@selector(postReply:) forControlEvents:UIControlEventTouchDown];

        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame=CGRectMake(0, 0,self.view.frame.size.width/4, toolBarHeight);
        [collectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        UIImage *imageForCollectionButton = [UIImage imageNamed:@"brush"];
        [collectionBtn setImage:imageForCollectionButton forState:UIControlStateNormal];
        NSString *collectionBtnStr = @"点评";
        [collectionBtn setTitle:collectionBtnStr forState:UIControlStateNormal];
        collectionBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [collectionBtn setTitleColor:UIColorFromRGB(0x707070) forState:UIControlStateNormal];
        UIBarButtonItem *collectionBarBtn = [[UIBarButtonItem alloc] initWithCustomView:collectionBtn];
        [collectionBtn addTarget:self action:@selector(postBrush:) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem * flexibleSpaceItem = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                              target:self
                              action:NULL];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame=CGRectMake(0, 0,self.view.frame.size.width/4, toolBarHeight);
        NSString *orderBtnStr = @"正序浏览";
        [orderBtn setTitle:orderBtnStr forState:UIControlStateNormal];
        orderBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [orderBtn setTitleColor:UIColorFromRGB(0x707070) forState:UIControlStateNormal];
        UIBarButtonItem * orderItem = [[UIBarButtonItem alloc] initWithCustomView:orderBtn];
        [orderBtn addTarget:self action:@selector(postOrder:) forControlEvents:UIControlEventTouchDown];
        
        [toolBar setItems:@[orderItem,flexibleSpaceItem,collectionBarBtn,replyBarBtn]];
        _postToolBar = toolBar;
        
    }
    return _postToolBar;
}

-(PostHeaderView *)postHeaderView{
    if (!_postHeaderView) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"PostHeaderView" owner:nil options:nil];
        PostHeaderView *postHeaderView = [nibContents lastObject];
        
        //titleLabel计算高度
        NSDictionary *dictAttr = [RS_attributeStringFactory PostHeaderLabelAttribute];
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGFloat height = [self.topic.t_Name boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) options:options attributes:dictAttr context:nil].size.height;
        height = ceil(height+91);
        
        //初始化帖子信息
        postHeaderView.titleLabel.attributedText =  [[NSAttributedString alloc] initWithString:[@"" clearRN:self.topic.t_Name]  attributes:dictAttr];
        postHeaderView.sacnLabel.text = self.topic.t_scanNum;
        postHeaderView.replyLabel.text = self.topic.t_replyNum;
        postHeaderView.moneyLabel.text = @"";
        
        [postHeaderView setFrame:CGRectMake(0, -height, self.view.frame.size.width, height)];
        //postHeaderView.backgroundColor = [UIColor redColor];
        _postHeaderView = postHeaderView;
        
    }
    return _postHeaderView;
}


-(void)parePareCom{
    
    UITableView *tV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height) style:UITableViewStyleGrouped];
    tV.backgroundColor = [UIColor whiteColor];
    [tV registerNib:[UINib nibWithNibName:@"PostBodyTableViewCell" bundle:nil] forCellReuseIdentifier:@"PostBodyTableViewCell"];
    
    [tV registerNib:[UINib nibWithNibName:@"PostImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"PostImgTableViewCell"];
    
    [tV registerNib:[UINib nibWithNibName:@"PostHeaderTableViewCell" bundle:nil]  forHeaderFooterViewReuseIdentifier:@"PostHeaderTableViewCell"];
    
    [tV registerNib:[UINib nibWithNibName:@"PostTableViewFooterView" bundle:nil]  forHeaderFooterViewReuseIdentifier:@"PostTableViewFooterView"];
    
   // tV.separatorInset = UIEdgeInsetsMake(0,80, 0, 80);        // 设置端距，这里表示separator离左边和右边均80像素
    
    tV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tV.estimatedRowHeight = 80.f;
    tV.rowHeight = UITableViewAutomaticDimension;

    tV.delegate = self;
    tV.dataSource = self;
    _postTableView = tV;
    
    [_postTableView addSubview:self.postHeaderView];
    [_postTableView setContentInset:UIEdgeInsetsMake(self.postHeaderView.frame.size.height, 0, 0, 0)];
    [self.view addSubview:_postTableView];
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
    
    [self parePareCom];
    
    [self.view addSubview:self.postToolBar];
    
    //下拉刷新设置
    __weak typeof(self) weakSelf = self;
    FloorTVRefreshHeader *header =  [[FloorTVRefreshHeader alloc] init];
    header.ignoredScrollViewContentInsetTop = _postTableView.contentInset.top;
    [header setRefreshingBlock:^{
        [RsNetworking PostWithFid:weakSelf.topicId Page:1 Authorid:0 Order:self.order completionHandler:^(NSString *str) {
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
        NSInteger nextPage = 1 + weakSelf.currentPage > weakSelf.topic.t_maxPage ? 0 : 1 + weakSelf.currentPage;
        if (nextPage < 1){
            [weakSelf.postTableView.mj_footer endRefreshing];
            return;
        }
        [RsNetworking PostWithFid:weakSelf.topicId Page:nextPage Authorid:0 Order:self.order completionHandler:^(NSString *str) {
            ForumParse *forumParse =  [[ForumParse alloc] init] ;
            [forumParse HTMLParseContent:str];
            [weakSelf updateDataSource:forumParse appendData:YES];
            weakSelf.currentPage++;
            [weakSelf.postTableView.mj_footer endRefreshing];
        }];
    }];
    [self.postTableView.mj_header beginRefreshing];
}

-(void)updateDataSource:(ForumParse*)forumParse appendData:(BOOL)isAppend{
    
    self.topic = forumParse.topic;
    self.postHeaderView.sacnLabel.text =  self.topic.t_scanNum?self.topic.t_scanNum:@"";
    self.postHeaderView.replyLabel.text = self.topic.t_replyNum?self.topic.t_replyNum:@"";
    self.currentPage = self.topic.t_currentPage;
    self.postHeaderView.moneyLabel.text = self.topic.t_awardDetails;

    if (isAppend) {
    }else{
        @synchronized (self) {
            [self.floors removeAllObjects];
        }
    }
    @synchronized (self) {
        NSMutableArray *floorsVm = [NSMutableArray arrayWithCapacity:forumParse.floors.count];
        [forumParse.floors enumerateObjectsUsingBlock:^(Floor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FloorViewModel *fVm = [[FloorViewModel alloc] initWithModel:obj];
            [floorsVm addObject:fVm];
        }];
        [self.floors addObjectsFromArray:floorsVm];
    }
    
    [self.postTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma  -mark- tableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.floors.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.floors objectAtIndex:section].cellsVm.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     PostTableViewFooterView *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PostTableViewFooterView"];
    FloorViewModel *f = [self.floors objectAtIndex:section];
    cell.bodyLabel.text = f.publishTime;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    PostHeaderTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PostHeaderTableViewCell"];
    
    FloorViewModel *f = [self.floors objectAtIndex:section];
    
    cell.unameLabel.text = f.userName;
    cell.floorNumLabel.text = f.floorNum;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.headerImgView sd_setImageWithURL:f.headImg placeholderImage:nil];
    return cell;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"%d",indexPath.row);
    if (self.floors == nil) {
        NSLog(@"empty session: %ld",(long)indexPath.section);
    }
    if ([self.floors objectAtIndex:indexPath.section].cellsVm == nil) {
        NSLog(@"empty cell %ld",(long)indexPath.section);
    }
    FloorBasicVM *vm = [[self.floors objectAtIndex:indexPath.section].cellsVm objectAtIndex:indexPath.row];

    id Recell = nil;
    switch (vm.type) {
        case VMTypeBody:
        {
            PostBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostBodyTableViewCell"];
            cell.bodyTextView.attributedText = vm.attributeStr;
            cell.bodyTextView.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle= UITableViewCellSelectionStyleNone ;
            Recell = cell;
            break;
        }
        case VMTypeImage:
        {
                PostImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostImgTableViewCell"];
            
                __weak typeof(self) weakSelf = self;
                __weak typeof(indexPath) weakIndex = indexPath;
                __weak typeof(vm) weakVM = vm;
                cell.imgView.image = nil;
            
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:vm.src] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   //计算高度
                    dispatch_main_async_safe(^{
                        if (!image) {
                            return;
                        }
                        CGFloat width = image.size.width > (weakSelf.view.frame.size.width-10) ? weakSelf.view.frame.size.width-10:image.size.width;
                        CGFloat height = width * (image.size.height/image.size.width);
                        
                        if (weakVM.height != ceil(height)){
                                @synchronized (weakSelf) {
                                    weakVM.height = ceil(height);
                                }
                                NSArray *visibleCells =  [self.postTableView indexPathsForVisibleRows];
                                if( [visibleCells containsObject:weakIndex]){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf.postTableView reloadData];
                                    });
                                }
                            }
                         });
                    }];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                if (vm.height!=0) {
                    cell.heightCon.constant = vm.height;
                    [cell setNeedsUpdateConstraints];
                    [cell updateConstraintsIfNeeded];
                }else{
                    if (cell.imgView.image) {
                        UIImage *image  = cell.imgView.image;
                        CGFloat width = image.size.width > (weakSelf.view.frame.size.width-10) ? weakSelf.view.frame.size.width-10:image.size.width;
                        CGFloat height = width * (image.size.height/image.size.width);
                        weakVM.height = ceil(height);
                        cell.heightCon.constant = weakVM.height;
                    }else{
                        cell.heightCon.constant = 50;
                    }
                    [cell setNeedsUpdateConstraints];
                    [cell updateConstraintsIfNeeded];
                }
                cell.selectionStyle= UITableViewCellSelectionStyleNone ;
                               Recell = cell;
                break;
        }
        case VMTypeQuote:
        {
            PostBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostBodyTableViewCell"];
            cell.bodyTextView.attributedText = vm.attributeStr;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.bodyTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
            cell.selectionStyle= UITableViewCellSelectionStyleNone ;
            Recell = cell;
            break;
        }
        case VMTypePstatus:
        {
            PostBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostBodyTableViewCell"];
            cell.bodyTextView.attributedText = vm.attributeStr;
            cell.bodyTextView.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle= UITableViewCellSelectionStyleNone ;
            Recell = cell;
            break;
        }
        default:

            break;
    }
       return (__kindof UITableViewCell*)Recell;
}
#pragma  -mark- tableViewDelegate



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isMemberOfClass:[PostBodyTableViewCell class]]) {
         FloorBasicVM *vm = [[self.floors objectAtIndex:indexPath.section].cellsVm objectAtIndex:indexPath.row];
         PostBodyTableViewCell *RealCell = (PostBodyTableViewCell *)cell;
         [RealCell.bodyTextView updateAttachment:vm.attachments];
    }
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FloorViewModel *f = [self.floors objectAtIndex:indexPath.se];
    if (f.needReCaculateHeight) {
        [f reCaculateheight:self.postTableView.frame.size.width];
    }
    return 200;
}*/




@end
