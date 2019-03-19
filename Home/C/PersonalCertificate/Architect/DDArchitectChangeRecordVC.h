//
//  DDArchitectChangeRecordVC.h
//  GongChengDD
//
//  Created by xzx on 2018/9/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 变更记录
 3一级结构师
 4二级结构师
 5化工工程师
 6一级建筑师
 7二级建筑师
 8土木工程师
 9公用设备师
 10电气工程师
 11监理工程师
 12造价工程师
 13消防工程师
 */
@interface DDArchitectChangeRecordVC : UIViewController

/**
 人员id
 */
@property (nonatomic,copy) NSString *staffId;
/**
 3一级结构师 4二级结构师 5化工工程师列表 6一级建筑师 7二级建筑师 8土木工程师 9公用设备师 10电气工程师 11监理工程师 12造价工程师 13消防工程师
 */
@property (nonatomic,copy) NSString *type;
@property (weak,nonatomic)UIViewController * mainViewContoller;

@end

NS_ASSUME_NONNULL_END
