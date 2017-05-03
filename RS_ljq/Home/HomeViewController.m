//
//  HomeViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UINavigationBar+Awesome.h"

#import "FloorTVRefreshHeader.h"
#import "HomeViewController.h"
#import "RsNetworking.h"
#import "HomeParse.h"

#import "ProfileModel.h"

#import "ProfileHeaderView.h"

#define defaultHeight 200
#define rawSpace 5

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray<NSString *> *profileColumns;

@property(nonatomic,strong) NSArray<NSString *> *staticsColumns;
@property(nonatomic,strong) NSArray<UILabel *> *staticsLabels;
@property(nonatomic,strong) UIStackView *staticsView;

@property(nonatomic,strong) ProfileHeaderView *profileHeaderView;

@property(nonatomic,strong) UITableView *profileTableView;

@end

@implementation HomeViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _profileColumns.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.profileColumns objectAtIndex:indexPath.row];
    return cell;
}


-(UITableView *)profileTableView{
    if (_profileTableView == nil) {
        _profileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _profileTableView.delegate = self;
        _profileTableView.dataSource = self;
    }
    return _profileTableView;
}
-(ProfileHeaderView *)profileHeaderView{
    if (_profileHeaderView == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"profileHeader" owner:nil options:nil];
        ProfileHeaderView *h = [nibContents lastObject];
        [h setFrame:CGRectMake(0, -370, self.view.frame.size.width, 200)];
        _profileHeaderView = h;
    }
    return _profileHeaderView;
}
-(UIStackView *)staticsView{
    if (_staticsView == nil) {
        NSMutableArray *views = [NSMutableArray array];
        [_staticsColumns enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel*v = [[UILabel alloc] init];
            v.text = obj;
            v.text = [NSString stringWithFormat:@"-\n%@",v.text];
            v.textAlignment = NSTextAlignmentCenter;
            v.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
            v.numberOfLines = 2;
            UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:0.2];
            v.backgroundColor = color;
            [views addObject:v];
        }];
        _staticsLabels = views;
        
        CGFloat UIStackViewHeight = self.view.frame.size.width/3;
        UIStackView *c =  [[UIStackView alloc] initWithFrame:CGRectMake(10, -UIStackViewHeight-5, self.view.frame.size.width-20, UIStackViewHeight)];
        c.distribution = UIStackViewDistributionFillEqually;
        c.axis = UILayoutConstraintAxisVertical ;
        UIStackView *hStackView1 = [[UIStackView alloc] initWithArrangedSubviews:[views subarrayWithRange:NSMakeRange(0, 4)]];
        hStackView1.spacing = 10;
        hStackView1.distribution = UIStackViewDistributionFillEqually;
        UIStackView *hStackView2 = [[UIStackView alloc] initWithArrangedSubviews:[views subarrayWithRange:NSMakeRange(4, 4)]];
        hStackView2.distribution = UIStackViewDistributionFillEqually;
        hStackView2.spacing = 10;
        c.spacing = 10;
        
        [c addArrangedSubview:hStackView1];
        [c addArrangedSubview:hStackView2];
        _staticsView = c;
    }
    return _staticsView;
}


-(void)prePareVC{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
    self.navigationItem.title = @"个人中心";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)prePareViews{
    [self.profileTableView addSubview:self.staticsView];
    self.profileHeaderView.frame = CGRectMake(0, -(2*rawSpace+defaultHeight+self.staticsView.frame.size.height), self.view.frame.size.width, defaultHeight);
    self.profileTableView.contentInset = UIEdgeInsetsMake(2*rawSpace+defaultHeight+self.staticsView.frame.size.height, 0, 0, 0);
    [self.profileTableView addSubview:self.profileHeaderView];
    [self.view addSubview:self.profileTableView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _profileColumns = [NSArray arrayWithObjects:@"个人信息",@"活跃概况",@"签到详情",@"统计信息",@"退出登录", nil];
    _staticsColumns = [NSArray arrayWithObjects:@"好友数",@"记录数",@"日志数",@"相册数",@"回帖数",@"主题数",@"分享数",@"", nil];

    [self prePareVC];
    [self prePareViews];
    
    __weak typeof(self) weakSelf = self;
    FloorTVRefreshHeader *header =  [[FloorTVRefreshHeader alloc] init];
    header.ignoredScrollViewContentInsetTop = self.profileTableView.contentInset.top;
    [header setRefreshingBlock:^{
        [RsNetworking homePage:76373 andType:@"profile" completionHandler:^(NSString *str) {
            HomeParse *hParse = [[HomeParse alloc] init];
            [hParse HTMLParseContentOfProfile:str];
            [weakSelf updateProfile:hParse.pModel];
            [weakSelf.profileTableView.mj_header endRefreshing];
        }];
    }];
    self.profileTableView.mj_header = header;
    
    [header beginRefreshing];
    
}

-(void)updateProfile:(ProfileModel *)pModel{
    //更新基本信息
    [_profileHeaderView.headerImg sd_setImageWithURL:[NSURL URLWithString:pModel.u_HeadImage] placeholderImage:nil];
    _profileHeaderView.nameLabel.text = [NSString stringWithFormat:@"%@\n%ld",pModel.u_Name,(long)pModel.u_Id];
    
    _profileHeaderView.groupLabel.text = [NSString stringWithFormat:@"%@\n%@",pModel.u_GroupInformation[0],pModel.u_GroupInformation[1]];
    
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] init];
    [pModel.u_Signature enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *s = [NSString stringWithFormat:@"%@: %@\n",key,obj];
            NSMutableAttributedString *attrs =  [[NSMutableAttributedString alloc] initWithString:s] ;
            [attrs addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:0.5] range:NSMakeRange(0, key.length)];
            [mStr appendAttributedString:attrs];
        }];
    [mStr addAttributes:[self strAttribute] range:NSMakeRange(0, mStr.length)];
    self.profileHeaderView.signatureLabel.attributedText = mStr;
    [self reLayoutViews:[self heightForString]];
    
    [pModel.u_Statistical enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.staticsLabels[idx].text = [NSString stringWithFormat:@"%ld\n%@",(long)[obj integerValue],self.staticsColumns[idx]];
    }];
    
}

-(void)reLayoutViews:(CGFloat)height{
    
    /*CGFloat headerHeight = height+102;
    self.profileHeaderView.frame = CGRectMake(0, -(2*rawSpace+headerHeight+self.staticsView.frame.size.height), self.view.frame.size.width, headerHeight);
    [self.profileTableView setContentInset:UIEdgeInsetsMake(900, 0, 0, 0)];
    
    self.profileTableView.mj_header.ignoredScrollViewContentInsetTop = self.profileTableView.contentInset.top;
    NSLog(@"%f",self.profileTableView.contentInset.top);
    [self.profileTableView reloadData];
     */
}

-(NSDictionary *)strAttribute{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 2;
    //段落间距
    paragraph.paragraphSpacing = 5;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    //paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    //paragraph.headIndent = 10;
    NSDictionary *dictAttr = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] , NSParagraphStyleAttributeName : paragraph};
    return [dictAttr copy];
}

-(CGFloat)heightForString{
    CGSize sizeToFit = [self.profileHeaderView.signatureLabel.text boundingRectWithSize:CGSizeMake(self.profileHeaderView.signatureLabel.frame.size.width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                          attributes:[self strAttribute]        // 文字的属性
                                                             context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}


@end
