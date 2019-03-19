//
//  DDCompanySafemanModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanySafemanModel : JSONModel

/*
 cert_level = "一级建造师";
 cert_no = "0173570";
 cert_type_id = "110001";
 formal = 1;
 has_b_certificate = 0;
 name = "卫德清"
 project_count = 0;
 registration_status = 0;
 registration_term = 60;
 speciality = "建筑工程";
 staff_info_id = 1452522884924672;
 validity_period_end = "2012-07-13";
 validity_period_end_days = -2210;
 */

@property (nonatomic,copy) NSString <Optional> *user_id;//人员id
@property (nonatomic,copy) NSString <Optional> *certId;//证书id
@property (nonatomic,copy) NSString <Optional> *cert_level;//证书级别
@property (nonatomic,copy) NSString <Optional> *cert_no;//证书编号
@property (nonatomic,copy) NSString <Optional> *cert_type_id;//证书类别id
@property (nonatomic,copy) NSString <Optional> *formal;//0非临时,1临时
@property (nonatomic,copy) NSString <Optional> *has_b_certificate;//B类证情况,1有,其它无
@property (nonatomic,copy) NSString <Optional> *name;//人员姓名
@property (nonatomic,copy) NSString <Optional> *project_count;//项目数量
@property (nonatomic,copy) NSString <Optional> *registration_status;////0可报名 1已报名 2不可报名
@property (nonatomic,copy) NSString <Optional> *registration_term;//报名截止剩余天数
@property (nonatomic,copy) NSString <Optional> *speciality;//专业
@property (nonatomic,copy) NSString <Optional> *claim;//0是未认领，1是已认领
@property (nonatomic,copy) NSString <Optional> *cert_state_source;//是否有效
@property (nonatomic,copy) NSString <Optional> *cert_type;//证书类别
@property (nonatomic,copy) NSString <Optional> *cert_type_name;//证书姓名
@property (nonatomic,copy) NSString <Optional> *staff_info_id;//人员id
@property (nonatomic,copy) NSString <Optional> *validity_period_end;//有效期日期
@property (nonatomic,copy) NSString <Optional> *validity_period_end_days;//有效期剩余天数

@end
