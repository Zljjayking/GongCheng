//
//  DDSearchCompanyListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/18.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchCompanyListModel : JSONModel

/*
 cert = <null>;
 certTypeSource = <null>;
 creditItem = <null>;
 dist = <null>;
 enterpriseId = 8719;
 enterpriseName = <null>;
 establishedDate = <null>;
 flagList = <null>;
 flagstatus = "2";
 fxxxCount = 0
 hjryCount = 0;
 id = 8719;
 legalRepresentative = "董玉";
 mergerName = "江苏省,南京市,江宁区";
 parentId = "22、22、22、22、22、22、22、22";
 phone = <null>;
 position = <null>;
 registerAddressSource = "南京市江宁区淳化街道青龙社区魏村27幢";
 registerCapital = <null>;
 registerCapitalCurrency = <null>;
 registerRegionId = 320115;
 ryzsCount = 0;
 score = <null>;
 staffInfoId = 1053250;
 status = "在业";
 taxNumber = <null>;
 unitName = "江苏硕宇建设有限公司";
 usedNames = <null>;
 validityPeriodEnd = <null>;
 zbCount = 0;
 zzCount = 8;
 */

@property (nonatomic, copy) NSString <Optional> *cert;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *legalRepresentative;//法人
@property (nonatomic, copy) NSString <Optional> *mergerName;
@property (nonatomic, copy) NSString <Optional> *parentId;
@property (nonatomic, copy) NSString <Optional> *registerRegionId;
@property (nonatomic, copy) NSString <Optional> *staffInfoId;
@property (nonatomic, copy) NSString <Optional> *unitName;
@property (nonatomic, copy) NSString <Optional> *usedNames;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *flagstatus;

@property (nonatomic, copy) NSAttributedString <Optional> *unitNameAttriStr;
@property (nonatomic, copy) NSAttributedString <Optional> *peopleAttriString;
@property (nonatomic, copy) NSAttributedString <Optional> *certAttriString;
@property (nonatomic, copy) NSString <Optional> *areaStr;
@property (nonatomic, copy) NSAttributedString <Optional> *usedNamesAttriString;

@property (nonatomic, copy) NSString <Optional> *zzCount;//资质数量
@property (nonatomic, copy) NSString <Optional> *zbCount;//中标数量
@property (nonatomic, copy) NSString <Optional> *fxxxCount;//风险信息数量
@property (nonatomic, copy) NSString <Optional> *hjryCount;//获奖荣誉数量
@property (nonatomic, copy) NSString <Optional> *ryzsCount;//人员证书数量
@property (nonatomic, copy) NSString <Optional> *xyqkCount;//信用情况数量

- (void)handle;

@end
