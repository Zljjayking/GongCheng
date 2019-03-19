//
//  DDCompanyDetailModel1.h
//  GongChengDD
//
//  Created by xzx on 2018/5/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDInfoModel<NSObject>
@end

@interface DDInfoModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *economicTypeSource;
@property (nonatomic,copy)NSString <Optional> *enterpriseId;
@property (nonatomic,copy)NSString <Optional> *enterpriseName;
@property (nonatomic,copy)NSString <Optional> *legalRepresentative;
@property (nonatomic,copy)NSString <Optional> *registerRegionAddress;
@property (nonatomic,copy)NSString <Optional> *socialCreditCode;
@property (nonatomic,copy)NSString <Optional> *updateTime;
@property (nonatomic,copy)NSString <Optional> *visits;
@end


@protocol DDTotalBillModel<NSObject>
@end

@interface DDTotalBillModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *lastBillDate;
@property (nonatomic,copy)NSString <Optional> *totalAmount;
@property (nonatomic,copy)NSString <Optional> *totalNum;
@end


@interface DDCompanyDetailModel1 : JSONModel

/*
 attention = <null>;
 attestation = <null>
 info = {
 economicTypeSource = "";
 enterpriseId = 1371064549769472;
 enterpriseName = "南京宏昌建设工程有限公司";
 legalRepresentative = "孙先保";
 registerRegionAddress = "南京市溧水区"
 socialCreditCode = "913201171357926821";
 updateTime = "1900-01-01 00:00:00";
 visits = 11;
 };
 totalBill = <null>;
 */

@property (nonatomic,copy)  DDInfoModel <Optional> *info;
@property (nonatomic, copy) DDTotalBillModel <Optional> *totalBill;
@property (nonatomic, copy) NSString <Optional> *attestation;//1已认证、2认证中 3未通过认证
@property (nonatomic, copy) NSString <Optional> *attention;//关注类型 1以上都关注   2中标情况  3证书情况 为空是没关注

@end
