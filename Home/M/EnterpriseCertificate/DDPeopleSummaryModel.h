//
//  DDPeopleSummaryModel.h
//  GongChengDD
//
//  Created by Koncendy on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 certNo = "00368545";
 certState = <null>;
 cert_level = "";
 enterpriseId = 40648;
 formal = 1;
 hasBCertificate = 0;
 name = "王立军"
 registeredNo = "苏232080824720";
 specialityName = "建筑工程";
 staffInfoId = 479837;
 type = 2;
 typeName = "二级建造师";
 validityPeriodEnd = "2011-10-30";
 validityPeriodEndDays = -2553;
 */
@interface DDPeopleSummaryModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certNo;//证书编号
@property (nonatomic,copy) NSString<Optional> *enterpriseId;//企业id
@property (nonatomic,copy) NSString<Optional> *hasBCertificate;//B类证情况:0无 1有
@property (nonatomic,copy) NSString<Optional> *name;//姓名
@property (nonatomic,copy) NSString<Optional> *specialityName;//专业名
@property (nonatomic,copy) NSString<Optional> *staffInfoId;
@property (nonatomic,copy) NSString<Optional> *type;//类型，  1一级建造师  2二级建造师  3安全员 4一级结构师 5二级结构师 6化工工程师列表7一级建筑师  8二级建筑师9土木工程师   10公用设备师  11电气工程师   12监理工程师  13造价工程师   14消防工程师
@property (nonatomic,copy) NSString<Optional> *typeName;//类型名称
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//有效期
@property (nonatomic,copy) NSString<Optional> *registeredNo;//注册号
@property (nonatomic,copy) NSString<Optional> *cert_level;//证书级别
@property (nonatomic,copy) NSString<Optional> *formal;//0临时
@property (nonatomic,copy) NSString<Optional> *regionId;
@end
