//
//  DDExaminationNoticeDetailVC.h
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DDMoneySelectView.h"//金额筛选View
#import "DDExamCitySelectView.h"//市的选择View

@interface DDExaminationNoticeDetailVC : UIViewController

@property (nonatomic,strong) NSString *titleName;//导航标题
@property (nonatomic,strong) NSString *certType;//类型
@property (nonatomic,strong) NSString *type;//搜索的类型,1:表示建造师，2:表示八大员和安全员

@property (nonatomic,strong) UIImageView *imgView1;//放左边那个城市选择小箭头
@property (nonatomic,strong) DDExamCitySelectView *townSelectTableView;//区域筛选视图
@property (nonatomic,strong) UIImageView *imgView2;//放右边那个资质等级选择小箭头
//@property (nonatomic,strong) DDMoneySelectView *moneySelectView;//金额筛选视图
@property (nonatomic,strong) NSString *isCitySelected;//判断是否点开了城市选择视图
@property (nonatomic,strong) NSString *isMoneySelected;//判断是否点开了金额筛选视图

-(void)requestData;

@end
