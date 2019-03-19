//
//  DDCompanyDetailModel1.h
//  GongChengDD
//
//  Created by xzx on 2018/5/24.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 {
 code = 0
 data = {
 attention = <null>;
 attestation = 2
 info = {
 address = "南京市秦淮区苜蓿园大街88号南楼17层A座";
 contactNumber = <null>;
 economicTypeSource = "有限责任公司";
 email = <null>;
 enterpriseId = 1371820390547712;
 enterpriseName = "南京大源生态建设集团有限公司";
 establishedDate = "1997-11-25 00:00:00";
 legalRepresentative = "金玲";
 offcialWebsite = <null>;
 registerCapital = 40000000;
 registerCapitalCurrency = 0;
 socialCreditCode = "91320100249984076P";
 updateTime = "1900-01-01 00:00:00"
 visits = 2;
 };
 totalBill = {
 toAction = "winBill";
 totalAmount = 0;
 totalNum = 0
 };
 };
 msg = "success";
 }
 

 
 */

@interface DDInfoModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *address;
@property (nonatomic,copy)NSString <Optional> *email;
@property (nonatomic,copy)NSString <Optional> *offcialWebsite;
@property (nonatomic,copy)NSString <Optional> *economicTypeSource;
@property (nonatomic,copy)NSString <Optional> *contactNumber;
@property (nonatomic,copy)NSString <Optional> *enterpriseId;
@property (nonatomic,copy)NSString <Optional> *establishedDate;
@property (nonatomic,copy)NSString <Optional> *enterpriseName;
@property (nonatomic,copy)NSString <Optional> *legalRepresentative;
@property (nonatomic,copy)NSString <Optional> *legalRepresentativeId;
@property (nonatomic,copy)NSString <Optional> *registerCapital;
@property (nonatomic,copy)NSString <Optional> *registerCapitalCurrency;
@property (nonatomic,copy)NSString <Optional> *socialCreditCode;
@property (nonatomic,copy)NSString <Optional> *updateTime;
@property (nonatomic,copy)NSString <Optional> *status;
@property (nonatomic,copy)NSArray <Optional> *usedNames;
@property (nonatomic,copy)NSString <Optional> *visits;
@property (nonatomic,copy)NSString <Optional> *comprehensiveScore;//综合评分
@end


@interface DDTotalBillModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *lastBillDate;
@property (nonatomic,copy)NSString <Optional> *toAction;
@property (nonatomic,copy)NSString <Optional> *totalAmount;
@property (nonatomic,copy)NSString <Optional> *totalNum;
@end

@interface DDTotalScoreModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *num;
@property (nonatomic,copy)NSString <Optional> *score;
@end

@interface DDCompanyDetailModel1 : JSONModel

@property (nonatomic,copy)  DDInfoModel <Optional> *info;
@property (nonatomic,copy) DDTotalBillModel <Optional> *totalBill;
@property (nonatomic,copy) DDTotalScoreModel <Optional> *totalScore;
@property (nonatomic,copy) NSString <Optional> *attestation;//1已认证、2认证中 3未通过认证 -1超过5家 0未认证
@property (nonatomic,copy) NSString <Optional> *attention;//关注类型 1以上都关注   2中标情况  3证书情况 为空是没关注
@property (nonatomic,copy) NSString <Optional> *is_collect;//如果不为null,就是被收藏了
@property (nonatomic,copy) NSString <Optional> *user_email;//自己的邮箱
@property (nonatomic,copy) NSString <Optional> *open;//0未开通，隐藏考试培训  非0已开通 显示考试培训
@end
