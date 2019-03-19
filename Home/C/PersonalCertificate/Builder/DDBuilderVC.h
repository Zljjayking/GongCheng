//
//  DDBuilderVC.h
//  GongChengDD
//
//  Created by xzx on 2018/5/17.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBuilderVC : UIViewController

@property (nonatomic,strong) NSString *enterpriseId;
@property (nonatomic,strong) NSString *enterpriseName;
@property (nonatomic,strong) NSString *toAction;
@property (nonatomic,strong) NSString *isOpen;//0隐藏 非0显示
@property (nonatomic,strong) NSString *attestation;//-1（认领企业已经5家，跳认领公司列表）  1（通过，跳报名列表） 2（认领中，提示语“当前公司正在认领中”）  3，其他（认领失败，弹框去认领）
//1一级建造师  2二级建造师
@property (nonatomic,strong) NSString *certLevel;

@end
