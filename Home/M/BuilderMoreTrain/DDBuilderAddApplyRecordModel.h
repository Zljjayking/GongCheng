//
//  DDBuilderAddApplyRecordModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDBuilderAddApplyRecordModel : JSONModel

/*
 cert_no = "1245545455454";
 cert_state = 0;
 certificate_area = <null>;
 enterprise_name = "南京龙腾建设有限公司";
 file_id = 0;
 has_b_certificate = 1;
 id_card = "342122121251515545";
 major = "建筑工程";
 major_type = <null>
 name = "张三公";
 new_train_id = 980;
 subject_id = <null>;
 tel = "13776546725";
 validity_period_end = "2019-02-26";
 */

@property (nonatomic,copy) NSString <Optional> *cert_no;
@property (nonatomic,copy) NSString <Optional> *cert_state;
@property (nonatomic,copy) NSString <Optional> *certificate_area;
@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *file_id;
@property (nonatomic,copy) NSString <Optional> *has_b_certificate;
@property (nonatomic,copy) NSString <Optional> *id_card;
@property (nonatomic,copy) NSString <Optional> *major;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *major_type;
//@property (nonatomic,copy) NSString <Optional> *new_train_id;
@property (nonatomic,copy) NSString <Optional> *tel;
@property (nonatomic,copy) NSString <Optional> *validity_period_end;

@end
