//
//  DDBuyCompanyDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDCertTypeLevelListModel<NSObject>
@end

@interface DDCertTypeLevelListModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *num;
@property (nonatomic,copy)NSString <Optional> *value;
@end



@interface DDBuyCompanyDetailModel : JSONModel

/*
 assure = 0;
 certTypeLevel = <null>;
 certTypeLevelList = [
 {
 num = 1;
 value = "钢结构工程专业承包三级"
 },
 {
 num = 2;
 value = "建筑工程施工总承包三级"
 }
 ];
 contactNumber = <null>;
 creditDebt = 1;
 dealState = 0;
 economicTypeSource = "false";
 entId = 1384329405989120;
 enterpriseName = "江苏**建设工程有限公司";
 legalDispute = 1;
 loansQuestion = 0
 isCollection = 0;
 mergerName = "江苏省,南京市";
 price = 800;
 processWork = 0;
 regionId = 320100;
 saleType = 1;
 socialCreditCode = "913***************";
 */

@property (nonatomic,copy) NSString <Optional> *assure;
@property (nonatomic,copy) NSString <Optional> *auditTime;
@property (nonatomic,copy) NSString <Optional> *certTypeLevel;
@property (nonatomic,copy) NSString <Optional> *contactNumber;
@property (nonatomic,copy) NSString <Optional> *creditDebt;
@property (nonatomic,copy) NSString <Optional> *dealState;
@property (nonatomic,copy) NSString <Optional> *economicTypeSource;
@property (nonatomic,copy) NSString <Optional> *entId;
@property (nonatomic,copy) NSString <Optional> *enterpriseName;
@property (nonatomic,copy) NSString <Optional> *isCollection;
@property (nonatomic,copy) NSString <Optional> *legalDispute;
@property (nonatomic,copy) NSString <Optional> *loansQuestion;
@property (nonatomic,copy) NSString <Optional> *mergerName;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *processWork;
@property (nonatomic,copy) NSString <Optional> *regionId;
@property (nonatomic,copy) NSString <Optional> *saleType;
@property (nonatomic,copy) NSString <Optional> *socialCreditCode;
@property (nonatomic,copy)  NSArray <Optional,DDCertTypeLevelListModel> *certTypeLevelList;

@end
