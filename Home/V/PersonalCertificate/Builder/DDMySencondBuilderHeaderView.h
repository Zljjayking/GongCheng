//
//  DDMySencondBuilderHeaderView.h
//  GongChengDD
//
//  Created by csq on 2018/7/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyBuilderModel.h"
/*
 cert_level = "二级建造师";
 has_b_certificate = 1
 name = "杨建安1";
 project_count = 0;
 qualification_cert_no = "苏232080905758";
 speciality = "建筑工程";
 staff_info_id = 1452523223909632;
 validity_period_end = "2018-06-05";
 validity_period_end_days = 0;
 */

@class DDMySencondBuilderHeaderView;
@protocol DDMySencondBuilderHeaderViewDelegate<NSObject>
@optional
//在线报名
- (void)mySencondBuilderHeaderViewClickReSignup:(DDMySencondBuilderHeaderView*)sencondBuilderHeaderView;
@end

@interface DDMySencondBuilderHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *residueDaysBgView;//剩余天数背景View
@property (weak, nonatomic) IBOutlet UILabel *specialityMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *specialityLab;
@property (weak, nonatomic) IBOutlet UILabel *certNoMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *certNoLab;
@property (weak, nonatomic) IBOutlet UILabel *hasBCerMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *hasBCerLab;
@property (weak, nonatomic) IBOutlet UILabel *validityMarkLab;
@property (weak, nonatomic) IBOutlet UILabel *validityLab;
@property (weak, nonatomic) IBOutlet UILabel *signUpLab;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *residueBgImageView;//橙色图片
@property (weak, nonatomic) IBOutlet UILabel *residueMarkLab;//剩余lab
@property (weak, nonatomic) IBOutlet UILabel *residueDayLab;//剩余天数lab


@property (weak, nonatomic)id<DDMySencondBuilderHeaderViewDelegate>delegate;

@end
