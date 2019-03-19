//
//  DDAptitudeCertificateModel.h
//  GongChengDD
//
//  Created by csq on 2017/11/30.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 certNo = "D132016209";
 enterpriseId = 1006069980266521;
 issueDeptLevel = 1
 issuedDeptId = "1";
 issuedDeptSource = "住房和城乡建设部";
 qualificationCertificateId = 10121212;
 validityPeriodEnd = "2020-11-30 00:00:00";
 */
@protocol DDAptitudeCertificateModel
@end
@interface DDAptitudeCertificateModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certNo;//证书编号
@property (nonatomic,copy) NSString<Optional> *enterpriseId;//企业id
@property (nonatomic,copy) NSString<Optional> *issueDeptLevel;//发证行政级别 0和1是部级  2是省级  3市级
@property (nonatomic,copy) NSString<Optional> *issueDeptLevelName;//发证行政级别名称
@property (nonatomic,copy) NSString<Optional> *issuedDeptId;//发证机关id
@property (nonatomic,copy) NSString<Optional> *issuedDeptSource;//发证机关名称
@property (nonatomic,copy) NSString<Optional> *qualificationCertificateId;//资质id
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;// 到期时间

@property (nonatomic,copy) NSString <Optional> * expiryTime;
@property (nonatomic,copy) NSString <Optional> * expiryStr;
@property (nonatomic,copy) NSString <Optional> * countDown;


- (NSString*)tranformLevel;

@end
