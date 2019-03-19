//
//  DDSafeManMoreTrainModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDSafeManMoreTrainModel : JSONModel

/*
 cert_no = "苏建安C(2014)0120533";
 cert_type = "C";
 cert_type_id = "170003";
 name = "石原里美"
 personal_certificate_id = 1452522876437760;
 project_count = 3;
 registration_status = 2;
 staff_info_id = 1452523259725555;
 tel = <null>;
 validity_period_end = "2018-09-22";
 validity_period_end_days = 71;
 */

@property (nonatomic,copy) NSString <Optional> *cert_no;
@property (nonatomic,copy) NSString <Optional> *cert_type;
@property (nonatomic,copy) NSString <Optional> *cert_type_id;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *personal_certificate_id;
@property (nonatomic,copy) NSString <Optional> *project_count;
@property (nonatomic,copy) NSString <Optional> *registration_status;
@property (nonatomic,copy) NSString <Optional> *staff_info_id;
@property (nonatomic,copy) NSString <Optional> *tel;
@property (nonatomic,copy) NSString <Optional> *tel_after;
@property (nonatomic,copy) NSString <Optional> *user_id;
@property (nonatomic,copy) NSString <Optional> *cert_state;
@property (nonatomic,copy) NSString <Optional> *validity_period_end;
@property (nonatomic,copy) NSString <Optional> *validity_period_end_days;
@property (nonatomic,copy) NSString <Optional> *id_card;
@property (nonatomic,copy) NSString <Optional> *employment_enterprise;

@end
