//
//  DDSafePermissionModel.h
//  GongChengDD
//
//  Created by csq on 2017/12/1.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>
/*
 certName = <null>;
 certificateNo = "(苏)JZ安许证字[2005]11111";
 createdTime = "2018-02-24 12:00:08";
 createdUserId = 0;
 deleted = 0;
 economicType = 10;
 economicTypeSource = "有限责任制";
 enterpriseId = 1229292237947136;
 enterpriseNameSource = "江苏康森迪信息科技有限公司";
 issuedDate = "2017-05-12 00:00:00";
 issuedDeptId = <null>;
 issuedDeptSource = "江苏省住房和城乡建设厅";
 licenseRange = "建筑施工";
 mainHead = "杜天海";
 safetyLicenceId = 1330833260545280;
 unitAddress = "南京市雨花台区软件大道180号07栋-207、208";
 unitAddressSource = "南京市雨花台区软件大道180号07栋-207、208";
 unitRegionId = 320100;
 updatedTime = "2018-02-24 12:00:08";
 updatedUserId = 0
 validityPeriodEnd = "2032-02-15 00:00:00";
 validityPeriodStart = "2017-05-12 00:00:00";
 */
@interface DDSafePermissionModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certificateNo;
@property (nonatomic,copy) NSString<Optional> *economicTypeSource;
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseNameSource;
@property (nonatomic,copy) NSString<Optional> *issuedDeptSource;
@property (nonatomic,copy) NSString<Optional> *licenseRange;
@property (nonatomic,copy) NSString<Optional> *mainHead;
@property (nonatomic,copy) NSString<Optional> *unitAddressSource;
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;
@property (nonatomic,copy) NSString<Optional> *validityPeriodStart;
@end
