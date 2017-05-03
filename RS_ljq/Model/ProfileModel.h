//
//  ProfileModel.h
//  RS_ljq
//
//  Created by lvjiaqi on 2017/5/3.
//  Copyright © 2017年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject

@property(nonatomic,strong) NSString* u_Name;
@property(nonatomic,assign) NSInteger u_Id;
@property(nonatomic,strong) NSString* u_HeadImage;
@property(strong,nonatomic) NSArray *u_Statistical;

@property(strong,nonatomic) NSDictionary *u_Signature;
@property(strong,nonatomic) NSDictionary *u_Details;

@property(strong,nonatomic) NSString* u_signInTotal;
@property(strong,nonatomic) NSString* u_signInMonth;
@property(strong,nonatomic) NSString* u_signInLastTime;

@property(assign,nonatomic) NSInteger u_AwardTotal;
@property(assign,nonatomic) NSInteger u_AwardLast;

@property(strong,nonatomic) NSString *u_signInGrade;
@property(strong,nonatomic) NSString *u_signInNextGrade;
@property(strong,nonatomic) NSString *u_signInNextGradeTime;

@property(strong,nonatomic) NSString *u_signInStatus;

@property(strong,nonatomic) NSArray *u_GroupInformation;

@property(strong,nonatomic) NSDictionary *u_ActiveInformation;
@property(strong,nonatomic) NSDictionary *u_StatisticalInformation;

-(NSString *)signatureStr;

@end
