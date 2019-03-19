//
//  DDCompanyBuilderModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanyBuilderModel : JSONModel

/*
 cert_level = "二级建造师";
 cert_no = "苏232060705726";
 cert_type_id = "120001";
 formal = 1;
 has_b_certificate = 1;
 name = "石原里美"
 project_count = 0;
 registration_status = 1;
 registration_term = 60;
 speciality = "建筑工程";
 staff_info_id = 1452523259725555;
 validity_period_end = "2017-01-08";
 validity_period_end_days = -570;
 */

@property (nonatomic,copy) NSString <Optional> *certId;//证书id
@property (nonatomic,copy) NSString <Optional> *user_id;//人员id
@property (nonatomic,copy) NSString <Optional> *cert_level;//证书级别
@property (nonatomic,copy) NSString <Optional> *cert_no;//证书编号
@property (nonatomic,copy) NSString <Optional> *cert_type_id;//证书类型id
@property (nonatomic,copy) NSString <Optional> *registered_no;//注册号
@property (nonatomic,copy) NSString <Optional> *formal;//0非临时,1临时
@property (nonatomic,copy) NSString <Optional> *has_b_certificate;//B类证情况,1有,其它无
@property (nonatomic,copy) NSString <Optional> *name;//姓名
@property (nonatomic,copy) NSString <Optional> *claim;//0是未认领，1是已认领
@property (nonatomic,copy) NSString <Optional> *project_count;//项目数量
@property (nonatomic,copy) NSString <Optional> *registration_status;//0可报名 1已报名 2不可报名
@property (nonatomic,copy) NSString <Optional> *registration_term;//报名截止剩余天数
@property (nonatomic,copy) NSString <Optional> *speciality;//专业
@property (nonatomic,copy) NSString <Optional> *staff_info_id;//人员id
@property (nonatomic,copy) NSString <Optional> *validity_period_end;//有效期
@property (nonatomic,copy) NSString <Optional> *validity_period_end_days;//有效期剩余天数
@property (nonatomic,copy) NSString <Optional> *qualification_cert_no;//资质证书编号


@end
