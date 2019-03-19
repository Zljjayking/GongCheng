//
//  DDNearCompanyVC.h
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 附近公司
 */
@interface DDNearCompanyVC : UIViewController
//入口方式 0列表 1企业详情 (必传)
@property (nonatomic,copy)NSString * type;
//企业id type为1时必传
@property (nonatomic,copy)NSString * enterpriseId;
//经纬度  type为0时必传
@property (nonatomic,copy)NSString * position;
@end

NS_ASSUME_NONNULL_END
