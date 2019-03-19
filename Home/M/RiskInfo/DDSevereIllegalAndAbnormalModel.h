//
//  DDSevereIllegalAndAbnormalModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSevereIllegalAndAbnormalModel : JSONModel

/*
 addDepartment = "闵行区市场监督管理局";
 addReason = "未依照《企业信息公示暂行条例》第八条规定的期限公示2017年度年度报告的";
 addTime = "2018-07-07";
 delDepartment = "山东省工商行政管理局"
 delReason = "列入经营异常名录届满3年仍未履行公示未依照《企业信息公示暂行条例》第八条规定的期限公示2017年度年度报告的";
 addTime = "2018-07-07";
 delDepartment = "山东省工商行政管理局"
 delReason = "列入经营异常名录届满3年仍未履行公示\344义务的，列入严重违法企业名单，自动移出";
 delTime = "2018-07-02";
 illegalId = 18;
 */

@property (nonatomic,copy) NSString <Optional> *addDepartment;
@property (nonatomic,copy) NSString <Optional> *addReason;
@property (nonatomic,copy) NSString <Optional> *addTime;
@property (nonatomic,copy) NSString <Optional> *delDepartment;
@property (nonatomic,copy) NSString <Optional> *delReason;
@property (nonatomic,copy) NSString <Optional> *delTime;
@property (nonatomic,copy) NSString <Optional> *illegalId;


@end

NS_ASSUME_NONNULL_END
