//
//  DDSearchCivilAndGreenGroundListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchCivilAndGreenGroundListModel : JSONModel

/*
 createdTime = <null>;
 createdUserId = <null>;
 enterpriseId = 3;
 enterpriseName = "七台河市鸿泰建设工程<font color='red'>公司</font>";
 executorDefendant = "浙江省住房和城乡建设厅";
 id = 3;
 imgUrl = <null>;
 regionId = 320102;
 rewardIssueTime = "2017-11-20"
 rewardOriginalHref = <null>;
 staffName = "张三";
 title = "生物全降解材料餐具项目二期工程被评为“2017年度全国绿色建筑创新奖项目”";
 type = 1;
 updatedTime = <null>;
 updatedUserId = <null>;
 year = <null>;
 */

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

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
