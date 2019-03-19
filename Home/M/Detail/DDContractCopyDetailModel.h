//
//  DDContractCopyDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/7.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDContractCopyDetailModel : JSONModel

/*
 build_nature = <null>;
 build_scale = <null>;
 contract_amount = <null>;
 contract_classify = <null>;
 contract_date = "2018-06-06";
 contract_number = "F0SG201700358";
 contract_type = "施工总包";
 contractor_company_code = "80231877-4";
 contractor_company_id = 1229292237947136;
 contractor_company_name = "江苏康森迪信息科技有限公司";
 engineering_purpose = <null>;
 enterprise_name = "南京金湖建筑安装工程有限公司";
 item_level = <null>;
 item_number = <null>;
 project_classify = "房屋建筑工程"
 project_name = "医疗辅助用房改扩建（望京医院医疗辅助用房改扩建）";
 project_number = "1101051710170102";
 project_province_number = "    F0SG201700358";
 project_region = "江苏省";
 record_date = "2018-06-06";
 record_number = "1101051710170102-HZ-001";
 record_province_number = "F0SG201700358";
 social_credit_code = "91420216986717435T";
 total_area = 6989.78;
 total_investment = 2800.09;
 union_contractor_company_code = <null>;
 union_contractor_company_name = <null>; */

@property (nonatomic,copy) NSString <Optional> *build_nature;
@property (nonatomic,copy) NSString <Optional> *build_scale;
@property (nonatomic,copy) NSString <Optional> *contract_amount;
@property (nonatomic,copy) NSString <Optional> *contract_classify;
@property (nonatomic,copy) NSString <Optional> *contract_date;
@property (nonatomic,copy) NSString <Optional> *contract_number;
@property (nonatomic,copy) NSString <Optional> *contract_type;
@property (nonatomic,copy) NSString <Optional> *contractor_company_code;
@property (nonatomic,copy) NSString <Optional> *contractor_company_id;
@property (nonatomic,copy) NSString <Optional> *contractor_company_name;
@property (nonatomic,copy) NSString <Optional> *engineering_purpose;
@property (nonatomic,copy) NSString <Optional> *builder_enterprise_name;
@property (nonatomic,copy) NSString <Optional> *item_level;
@property (nonatomic,copy) NSString <Optional> *item_number;
@property (nonatomic,copy) NSString <Optional> *project_classify;
@property (nonatomic,copy) NSString <Optional> *project_name;
@property (nonatomic,copy) NSString <Optional> *project_number;
@property (nonatomic,copy) NSString <Optional> *project_province_number;
@property (nonatomic,copy) NSString <Optional> *project_region;
@property (nonatomic,copy) NSString <Optional> *record_date;
@property (nonatomic,copy) NSString <Optional> *record_number;
@property (nonatomic,copy) NSString <Optional> *record_province_number;
@property (nonatomic,copy) NSString <Optional> *builder_enterprise_code;
@property (nonatomic,copy) NSString <Optional> *total_area;
@property (nonatomic,copy) NSString <Optional> *total_investment;
@property (nonatomic,copy) NSString <Optional> *union_contractor_company_code;
@property (nonatomic,copy) NSString <Optional> *union_contractor_company_name;
@property (nonatomic,copy) NSString <Optional> *out_contracting_company_name;
@property (nonatomic,copy) NSString <Optional> *out_contracting_company_code;

@end
