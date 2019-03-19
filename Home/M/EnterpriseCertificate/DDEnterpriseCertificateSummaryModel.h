//
//  DDEnterpriseCertificateSummaryModel.h
//  GongChengDD
//
//  Created by csq on 2017/12/4.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DDAptitudeCertificateModel.h"
/*
 {
 code = 0
 data = {
 QualificationValidity = [
 {
 certNo = "D132068668000";
 issueDeptLevel = 1;
 issueDeptLevelName = "部级";
 issuedDate = "2016-04-26 00:00:00";
 qualificationCertificateId = 1296558097368320;
 validityPeriodEnd = "2018-12-22 00:00:00"
 },
 {
 certNo = "D232086975000";
 issueDeptLevel = 2;
 issueDeptLevelName = "省级";
 issuedDate = "2016-04-01 00:00:00";
 qualificationCertificateId = 1296558101431552;
 validityPeriodEnd = "2021-04-01 00:00:00"
 },
 {
 certNo = "D332105147000";
 issueDeptLevel = 3;
 issueDeptLevelName = "市级";
 issuedDate = "2016-04-13 00:00:00";
 qualificationCertificateId = 1296558108148992;
 validityPeriodEnd = "2012-04-13 00:00:00"
 }
 ]
 businessLicense = {
 aicDeptId = "";
 businessScope = "信息技术、计算机软硬件技术开发、技术转让、技术咨询、技术服务；互联网信息服务；建筑材料、装饰材料、五金、家电、日用百货、普通机械设备销售；保险代理服务；企业管理咨询；建筑工程技术服务；企业形象设计；社会经济咨询；知识产权服务；企业管理体系认证咨询与服务。（依法须经批准的项目，经相关部门批准后方可开展经营活动）";
 checkInDeptSource = "南京市雨花台区市场监督管理局";
 createdTime = "2018-02-24 18:39:02";
 createdUserId = 0;
 deleted = 0;
 economicType = 10;
 economicTypeSource = "企业经济类型";
 enterpriseId = 1229292237947136;
 establishedDate = "2015-12-15 00:00:00";
 legalRepresentative = "杜天海";
 licenseId = 1331617529201920;
 registerAddressSource = "南京市雨花台区软件大道180号07栋-207、208";
 registerCapital = 150000000;
 registerCapitalCurrency = 0;
 registerRegionId = 320114
 socialCreditCode = "91320114MA1Q303R9K";
 unitName = "江苏康森迪信息科技有限公司";
 updatedTime = "2018-04-17 09:54:29";
 updatedUserId = 1000000100000001;
 validityPeriodEnd = "2018-12-22 00:00:00";
 };
 safetyLicence = {
 certificateNo = "(苏)JZ安许证字[2005]11111";
 createdTime = "2018-02-24 12:00:08";
 createdUserId = 0;
 deleted = 0;
 economicType = 10;
 economicTypeSource = "有限责任制";
 enterpriseId = 1229292237947136;
 enterpriseNameSource = "江苏康森迪信息科技有限公司";
 issuedDate = "2017-05-12 00:00:00";
 issuedDeptSource = "江苏省住房和城乡建设厅";
 licenseRange = "建筑施工";
 mainHead = "杜天海";
 safetyLicenceId = 1330833260545280;
 unitAddress = "南京市雨花台区软件大道180号07栋-207、208";
 unitAddressSource = "南京市雨花台区软件大道180号07栋-207、208";
 unitRegionId = 320100;
 updatedTime = "2018-02-24 12:00:08";
 updatedUserId = 0
 validityPeriodEnd = "2018-09-22 00:00:00";
 validityPeriodStart = "2017-05-12 00:00:00";
 };
 };
 msg = "success";
 }
 */

//安全生产许可证
@interface DDSafetyLicenceModel:JSONModel
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//到期时间
@end

//资质证书有效期
@protocol QualificationValidityModel;
@interface QualificationValidityModel:JSONModel
@property (nonatomic,copy) NSString<Optional> *issueDeptLevelName;
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//到期时间
@property (nonatomic,copy) NSString<Optional> *certNo;//证书编号
@end

//营业执照工商年报
@interface BusinessLicenseModel:JSONModel
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//到期时间
@end

@interface DDEnterpriseCertificateSummaryModel : JSONModel
@property (nonatomic,copy) NSString<Optional> * inspectionDate;//营业执照,年检时间,放在这里,格式怪的一笔
@property (nonatomic,strong) NSArray<Optional,QualificationValidityModel> *QualificationValidity;//资质证书
@property (nonatomic,strong) DDSafetyLicenceModel<Optional>*safetyLicence;//安全许可证
@property (nonatomic,strong) BusinessLicenseModel<Optional>*businessLicense;//营业执照
@end
