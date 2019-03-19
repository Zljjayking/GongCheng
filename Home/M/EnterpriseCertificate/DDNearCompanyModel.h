//
//  DDNearCompanyModel.h
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"
/*
 numFound = 5
 result = [
 {
 cert = <null>;
 certTypeSource = <null>;
 creditItem = <null>;
 dist = "0.9159042";
 enterpriseId = 2312618;
 enterpriseName = "陕西源林工程造价咨询有限公司";
 establishedDate = <null>;
 flagList = <null>;
 flagstatus = "2";
 id = <null>;
 legalRepresentative = <null>;
 mergerName = <null>;
 parentId = <null>;
 phone = <null>;
 position = <null>;
 registerAddressSource = "西安市高新区高新六路38号腾飞创新中心城B幢6层602单元";
 registerCapital = 1000000;
 registerCapitalCurrency = 0;
 registerRegionId = <null>;
 score = <null>;
 staffInfoId = <null>;
 status = "开业";
 taxNumber = <null>
 unitName = <null>;
 usedNames = <null>;
 validityPeriodEnd = <null>;
 },
 */
NS_ASSUME_NONNULL_BEGIN

@protocol DDNearCompanyResultModel <NSObject>
@end
@interface DDNearCompanyResultModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;
@property (nonatomic,copy) NSString<Optional> *dist;//距离,单位:千米
@property (nonatomic,copy) NSString<Optional> *registerCapital;//注册资本
@property (nonatomic,copy) NSString<Optional> *registerCapitalCurrency;//0人民币 1美元
@property (nonatomic,copy) NSString<Optional> *cert;//证书
@property (nonatomic,copy) NSString<Optional> *registerAddressSource;//注册地
@property (nonatomic,copy) NSString<Optional> *status;//状态
@property (nonatomic,copy) NSString<Optional> *flagstatus;
@end

@interface DDNearCompanyModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *numFound;
@property (nonatomic,copy) NSArray<Optional,DDNearCompanyResultModel> *result;
@end

NS_ASSUME_NONNULL_END
