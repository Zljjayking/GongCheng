//
//  DDCivilReceivedProjectsVC.h
//  GongChengDD
//
//  Created by xzx on 2018/10/16.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCivilReceivedProjectsVC : UIViewController

@property (nonatomic,strong) NSString *staffInfoId;
@property (nonatomic,strong) NSString *type;//8土木工程师  9公用设备师  10电气工程师  11监理工程师   12造价工程师
@property (nonatomic,strong) NSString *specialityCode;//专业code
@property (weak,nonatomic)UIViewController * mainViewContoller;

@end

NS_ASSUME_NONNULL_END
