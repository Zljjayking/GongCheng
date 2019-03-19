//
//  DDCompanyExcutedModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanyExcutedModel : JSONModel

/*
 execute_case_number = "（2013）粤0306执4964号";
 execute_court = "深证市宝安区人民法院";
 execute_create_date = "2018-05-29";
 execute_id = 3;
 execute_person = "江苏康森迪信息科技有限公司"
 execute_publish_date = "2018-05-30";
 execute_standard = "23043082";
 */

@property (nonatomic,copy) NSString <Optional> *execute_case_number;
@property (nonatomic,copy) NSString <Optional> *execute_court;
@property (nonatomic,copy) NSString <Optional> *execute_create_date;
@property (nonatomic,copy) NSString <Optional> *execute_id;
@property (nonatomic,copy) NSString <Optional> *execute_person;
@property (nonatomic,copy) NSString <Optional> *execute_publish_date;
@property (nonatomic,copy) NSString <Optional> *execute_standard;

@end
