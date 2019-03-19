//
//  DDAgencySelectModel.h
//  GongChengDD
//
//  Created by xzx on 2018/7/10.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

@interface DDAgencySelectModel : JSONModel

/*
 detail = "南京雨花区大数据产业基地";
 name = "培训机构";
 price = "建筑工程(200),机电工程(300),水利工程(600)";
 speciality_price = "200"
 train_agency_id = 1;
 train_explain = "报考说明";
 train_recommend = "机构介绍";
 */

@property (nonatomic,copy) NSString <Optional> *agency_major_id;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *train_agency_id;
@property (nonatomic,copy) NSString <Optional> *train_explain;
@property (nonatomic,copy) NSString <Optional> *train_recommend;
@property (nonatomic,copy) NSString <Optional> *speciality_price;
@property (nonatomic,copy) NSString <Optional> *isClosed;
@property (nonatomic,copy) NSString <Optional> *province;
@property (nonatomic,copy) NSString <Optional> *city;
@property (nonatomic,copy) NSString <Optional> *area;
/// 机构形象图
@property (nonatomic, copy) NSString *agencyImage;
/// 历史订单数
@property (nonatomic, assign) int  orderCnt;

@end
