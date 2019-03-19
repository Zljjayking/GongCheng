//
//  DDReceivedProjectsListVC.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCompanyBuilderModel.h"

@interface DDReceivedProjectsListVC : UIViewController

@property (nonatomic,strong) NSString *staffInfoId;
@property (nonatomic,strong) NSString *type;//0一级建造师 1二级建造师
@property (nonatomic,strong) NSString *specialityCode;//专业code
@property (weak,nonatomic)UIViewController * mainViewContoller;

@end
