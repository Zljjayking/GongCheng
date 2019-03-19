//
//  DDPeopleBelongCertiModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPeopleBelongCertiModel : JSONModel

/*
 cert_id = 1413426;
 cert_level = "";
 cert_no = "苏建安B(2007)0101583";
 cert_state = "有效";
 cert_type = "B";
 cert_type_name = "安全员B"
 claim = 0;
 data_type = 2;
 formal = <null>;
 has_b_certificate = 0;
 name = "严光龙";
 registered_no = "";
 speciality = "";
 speciality_code = "";
 staff_info_id = 1213679;
 user_id = <null>;
 validity_period_end = "2019-08-17";
 validity_period_end_days = 283;
 */
@property (nonatomic,copy) NSString <Optional> *cert_id;
@property (nonatomic,copy) NSString <Optional> *cert_no;
@property (nonatomic,copy) NSString <Optional> *cert_state;
@property (nonatomic,copy) NSString <Optional> *cert_type_name;
@property (nonatomic,copy) NSString <Optional> *data_type;
@property (nonatomic,copy) NSString <Optional> *has_b_certificate;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *speciality;
@property (nonatomic,copy) NSString <Optional> *speciality_code;
@property (nonatomic,copy) NSString <Optional> *staff_info_id;
@property (nonatomic,copy) NSString <Optional> *validity_period_end;
@property (nonatomic,copy) NSString <Optional> *validity_period_end_days;
@property (nonatomic,copy) NSString <Optional> *cert_type;
@property (nonatomic,copy) NSString <Optional> *formal;
@property (nonatomic,copy) NSString <Optional> *registered_no;
@property (nonatomic,copy) NSString <Optional> *cert_level;//1一级建造师 2二级建造师  
@property (nonatomic,copy) NSString <Optional> *claim;//0未认领  1已认领
@property (nonatomic,copy) NSString <Optional> *user_id;
@end
