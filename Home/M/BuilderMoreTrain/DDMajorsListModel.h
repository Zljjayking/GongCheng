//
//  DDMajorsListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDMajorsListModel : JSONModel

/*
 agency_major_id = 14980;
 cert_type_id = "120001";
 major_id = "120001"
 name = "建筑工程";
 price = 200;
 price_ext = 300;
 subjectList = [{
    agency_major_id = 14744;
    major_id = "120001";
    price = 12;
    subject_id = "920003";
    subject_name = "专业工程管理与实务"
 }]
 */

@property (nonatomic,copy) NSString <Optional> *agency_major_id;
@property (nonatomic,copy) NSString <Optional> *cert_type_id;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *price_ext;
@property (nonatomic,copy) NSString <Optional> *major_id;
@property (nonatomic,copy) NSArray <Optional> *subjectList;
@end
