//
//  DDBuilderMoreTrainModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/11.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDBuilderMoreTrainModel : JSONModel

/*
 cert_no = "";
 cert_type_id = "120001";
 certificate_id = 1452523218863360;
 formal = 1;
 has_b_certificate = 0;
 name = "潘卫海";
 project_count = 0;
 registration_status = 0;
 speciality = "建筑工程";
 staff_info_id = 1481530253575144;
 tel = <null>
 validity_period_end = "2018-03-12";
 validity_period_end_days = -122;
 */

@property (nonatomic,copy) NSString <Optional> *cert_no;
@property (nonatomic,copy) NSString <Optional> *cert_type_id;
@property (nonatomic,copy) NSString <Optional> *certificate_id;
@property (nonatomic,copy) NSString <Optional> *formal;
@property (nonatomic,copy) NSString <Optional> *has_b_certificate;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *project_count;
@property (nonatomic,copy) NSString <Optional> *registration_status;
@property (nonatomic,copy) NSString <Optional> *speciality;
@property (nonatomic,copy) NSString <Optional> *staff_info_id;
@property (nonatomic,copy) NSString <Optional> *tel;
@property (nonatomic,copy) NSString <Optional> *tel_after;
@property (nonatomic,copy) NSString <Optional> *validity_period_end;
@property (nonatomic,copy) NSString <Optional> *validity_period_end_days;
@property (nonatomic,copy) NSString <Optional> *user_id;
@property (nonatomic,copy) NSString <Optional> *id_card;
@property (nonatomic,copy) NSString <Optional> *employment_enterprise;

@end
