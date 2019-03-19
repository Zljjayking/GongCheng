//
//  DDSearchProjectListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchProjectListModel : JSONModel

/*
 amount = 479700;
 enterpriseId = 1375829334783400;
 hostUrl = <null>;
 image = <null>;
 isCollection = <null>;
 mergerName = "江苏省,南京市";
 moneyType = 0;
 projectManager = <null>;
 publishDate = "2018-08-24 00:00:00"
 regionId = 320100;
 staffInfoId = 0;
 title = "横溪中学建筑立面改造工程项目";
 tradingCenter = "南京市公共资源交易中心";
 type = 1;
 winBidOrg = "南京典筑建筑设计有限公司";
 winBidText = <null>;
 winCaseId = 1344616370241663;
 */

@property (nonatomic, copy) NSString <Optional> *amount;//中标金额数值
@property (nonatomic, copy) NSString <Optional> *mergerName;
@property (nonatomic, copy) NSString <Optional> *projectManager;
@property (nonatomic, copy) NSString <Optional> *publishDate;
@property (nonatomic, copy) NSString <Optional> *regionId;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *tradingCenter;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *winBidOrg;
@property (nonatomic, copy) NSString <Optional> *winCaseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *staffInfoId;
@property (nonatomic, copy) NSAttributedString <Optional> *titleString;
@property (nonatomic, copy) NSAttributedString <Optional> *winBidString;
@property (nonatomic, copy) NSAttributedString <Optional> *peopleString;
@property (nonatomic, copy) NSString <Optional> *moneyString;
@property (nonatomic, copy) NSString <Optional> *timeString;
@property (nonatomic, copy) NSString <Optional> *moneyType;//0中标金额是数值,1中标金额是文本
@property (nonatomic, copy) NSString <Optional> *winBidText;//中标金额文本

@property (nonatomic, copy) NSString <Optional> *win_bid_text;

- (void)handle;
//招标监控详情字段,与原字段无冲突,因使用地方过多无法直接更改,故添加字段以完善model
@property (nonatomic, copy) NSString <Optional> *accident;
@property (nonatomic, copy) NSString <Optional> *allcert;
@property (nonatomic, copy) NSString <Optional> *claim;
@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *isAbc;
@property (nonatomic, copy) NSString <Optional> *isArchitect;
@property (nonatomic, copy) NSString <Optional> *isBuilder;
@property (nonatomic, copy) NSString <Optional> *isChemicalEngineer;
@property (nonatomic, copy) NSString <Optional> *isCivilEngineer;
@property (nonatomic, copy) NSString <Optional> *isCostEngineer;
@property (nonatomic, copy) NSString <Optional> *isElectricalEngineer;
@property (nonatomic, copy) NSString <Optional> *isFireEngineer;
@property (nonatomic, copy) NSString <Optional> *isLegalRepresentative;
@property (nonatomic, copy) NSString <Optional> *isProjectManager;
@property (nonatomic, copy) NSString <Optional> *isStructural;
@property (nonatomic, copy) NSString <Optional> *isSupervisionEngineer;
@property (nonatomic, copy) NSString <Optional> *isUtilityEngineer;
@property (nonatomic, copy) NSString <Optional> *isopen;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *project;
@property (nonatomic, copy) NSString <Optional> *punish;
@property (nonatomic, copy) NSString <Optional> *reward;
@property (nonatomic, copy) NSString <Optional> *staff_info_id;

@property (nonatomic, copy) NSString <Optional> *created_time;
@property (nonatomic, copy) NSString <Optional> *invite_amount;
@property (nonatomic, copy) NSString <Optional> *invite_id;
@property (nonatomic, copy) NSString <Optional> *win_case_id;


@property (nonatomic, copy) NSString <Optional> *invite_text;
@property (nonatomic, copy) NSString <Optional> *money_type;
@property (nonatomic, copy) NSString <Optional> *project_type;
@property (nonatomic, copy) NSString <Optional> *publish_date;
@property (nonatomic, copy) NSString <Optional> *region_id;
@property (nonatomic, copy) NSString <Optional> *trading_center;

@property (nonatomic, copy) NSString <Optional> *win_bid_amount;//中标金额
@property (nonatomic, copy) NSString <Optional> *win_bid_org;//中标人
@end
