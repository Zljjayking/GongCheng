//
//  DDCultureWorkSiteModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 createdTime = "2018-09-20 08:34:45";
 createdUserId = 0;
 enterpriseId = 1;
 enterpriseName = "一重集团大连工程建设有限公司";
 executorDefendant = "浙江省住房和城乡建设厅
 
 ";
 id = 1;
 imgUrl = <null>;
 regionId = 320011;
 rewardIssueTime = "2018-09-20"
 rewardOriginalHref = "http://192.168.1.157:8180/solr/index.html#/allrap/query";
 staffName = "张三";
 title = "生物全降解材料餐具项目二期工程被评为“2017年度全国绿色建筑创新奖项目”";
 type = 1;
 updatedTime = "2018-09-21 11:22:52";
 updatedUserId = 0;
 year = "2017";
 */
@interface DDCultureWorkSiteModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *createdTime;
@property (nonatomic, copy) NSString <Optional> *createdUserId;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *executorDefendant;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *imgUrl;
@property (nonatomic, copy) NSString <Optional> *regionId;
@property (nonatomic, copy) NSString <Optional> *rewardIssueTime;
@property (nonatomic, copy) NSString <Optional> *rewardOriginalHref;
@property (nonatomic, copy) NSString <Optional> *staffName;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *updatedTime;
@property (nonatomic, copy) NSString <Optional> *updatedUserId;
@property (nonatomic, copy) NSString <Optional> *year;
@property (nonatomic, copy) NSString <Optional> *rewardExplain;
@end

NS_ASSUME_NONNULL_END
