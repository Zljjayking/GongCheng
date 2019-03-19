//
//  DDArchitectReceivedProjectsVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectReceivedProjectsVC : UIViewController

@property (nonatomic,strong) NSString *staffInfoId;
@property (nonatomic,strong) NSString *type;//3一级结构师 4二级结构师 5化工工程师列表 6一级建筑师 7二级建筑师
@property (nonatomic,strong) NSString *certiId;//证书id
@property (weak,nonatomic)UIViewController * mainViewContoller;

@end

NS_ASSUME_NONNULL_END
