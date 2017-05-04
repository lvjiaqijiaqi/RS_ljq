//
//  LoginInViewController.m
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/4.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import "LoginInViewController.h"
#import "LoginWorking.h"
#import "UINavigationBar+Awesome.h"

@interface LoginInViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UITextField *unameLabel;
@property (strong, nonatomic) IBOutlet UITextField *pwdLabel;

@property (strong, nonatomic) IBOutlet UIButton *loginInBtn;
@property (strong, nonatomic) IBOutlet UIButton *findPwdBtn;

@end

@implementation LoginInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self prePareVC];
    
}

-(void)prePareVC{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = @"登陆";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelLogin:)];
    
}

- (IBAction)loginInAction:(id)sender {
    [[LoginWorking sharedInstance] loginInRs:self.unameLabel.text and:self.pwdLabel.text success:^(NSString *msg){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"睿思欢迎你" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self loginSuccess];
        }];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    } failure:^(NSString *msg){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self loginFailure];
        }];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
}

-(IBAction)findPwdAction:(id)sender {
    
}

- (void)cancelLogin:(id)sender {
    [self loginSuccess];
}

-(void)loginSuccess{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)loginFailure{
    self.pwdLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
