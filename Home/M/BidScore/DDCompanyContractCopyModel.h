//
//  DDCompanyContractCopyModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/6.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanyContractCopyModel : JSONModel

/*
 contract_date = "2018-06-06";
 contract_number = "F0SG201700358"
 contract_type = "施工总包";
 project_name = "医疗辅助用房改扩建（望京医院医疗辅助用房改扩建）";
 record_id = 1;
 contract_amount = 6989.78;
 */

@property (nonatomic,copy) NSString <Optional> *contract_date;
@property (nonatomic,copy) NSString <Optional> *contract_number;
@property (nonatomic,copy) NSString <Optional> *contract_type;
@property (nonatomic,copy) NSString <Optional> *project_name;
@property (nonatomic,copy) NSString <Optional> *record_id;
@property (nonatomic,copy) NSString <Optional> *contract_amount;

@property (nonatomic,copy) NSString <Optional> *project_classify;
@property (nonatomic,copy) NSString <Optional> *record_number;
@property (nonatomic,copy) NSString <Optional> *enterprise_id;
@property (nonatomic,copy) NSString <Optional> *enterprise_name;

@property (nonatomic,copy) NSAttributedString <Optional> *nameString;
@property (nonatomic,copy) NSAttributedString <Optional> *enterpriseNameString;
@property (nonatomic,copy) NSString <Optional> *amountStr;

@end
