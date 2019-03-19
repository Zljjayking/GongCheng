//
//  DDTaxIllegalDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTaxIllegalDetailModel : JSONModel

/*
 address = "辽宁省大连市旅顺口区得胜街道英武街16号(901)";
 agencyIdcard = "-";
 agencyIdcardType = "-";
 agencyInfo = "-";
 agencyName = "-";
 agencySex = "-";
 content = "经大连市国家税务局第二稽查局检查，发现其在2012年01月01日至2014年12月31日期间，主要存在以下问题：采取偷税手段，不缴或者少缴应纳税款249.66万元。";
 createdTime = "2018-10-22 19:12:32";
 department = "-";
 enterpriseId = 99622;
 enterpriseName = "大连汇博建筑工程有限公司";
 financeChiefIdcard = "-";
 financeChiefIdcardType = "-";
 financeChiefName = "-";
 financeChiefSex = "-";
 illegalId = 10;
 legalIdcard = "210212********5910";
 legalIdcardType = "身份证";
 legalName = "任洪发"
 legalSex = "男";
 organizationCode = "77300955X";
 publishTime = <null>;
 taxpayerNum = "9121021277300955XQ";
 type = "偷税";
 updatedTime = "2018-10-26 10:56:36";
 */

@property (nonatomic,copy) NSString <Optional> *address;
@property (nonatomic,copy) NSString <Optional> *agencyIdcard;
@property (nonatomic,copy) NSString <Optional> *agencyIdcardType;
@property (nonatomic,copy) NSString <Optional> *agencyInfo;
@property (nonatomic,copy) NSString <Optional> *agencyName;
@property (nonatomic,copy) NSString <Optional> *agencySex;
@property (nonatomic,copy) NSString <Optional> *content;
@property (nonatomic,copy) NSString <Optional> *createdTime;
@property (nonatomic,copy) NSString <Optional> *department;
@property (nonatomic,copy) NSString <Optional> *enterpriseId;
@property (nonatomic,copy) NSString <Optional> *enterpriseName;
@property (nonatomic,copy) NSString <Optional> *financeChiefIdcard;
@property (nonatomic,copy) NSString <Optional> *financeChiefIdcardType;
@property (nonatomic,copy) NSString <Optional> *financeChiefName;
@property (nonatomic,copy) NSString <Optional> *financeChiefSex;
@property (nonatomic,copy) NSString <Optional> *illegalId;
@property (nonatomic,copy) NSString <Optional> *legalIdcard;
@property (nonatomic,copy) NSString <Optional> *legalIdcardType;
@property (nonatomic,copy) NSString <Optional> *legalName;
@property (nonatomic,copy) NSString <Optional> *legalSex;
@property (nonatomic,copy) NSString <Optional> *organizationCode;
@property (nonatomic,copy) NSString <Optional> *publishTime;
@property (nonatomic,copy) NSString <Optional> *taxpayerNum;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *updatedTime;

@end

NS_ASSUME_NONNULL_END
