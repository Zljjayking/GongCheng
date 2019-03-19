//
//  DDCompanyBuilderProjectModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanyBuilderProjectModel : JSONModel

/*
 enterprise_name = "南京金湖建筑安装工程有限公司";
 project_manager = "陈强";
 publish_date = "2018-01-16";
 summary = "（鼓楼区）南京市鼓楼区教育局2017年全区学校应急排险、绿化管养项目施工七标段";
 trading_center = "南京市公共资源交易中心";
 type = 1;
 win_bid_amount = 1098894.12
 win_case_id = 1344636713468416;
 */

@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *project_manager;
@property (nonatomic,copy) NSString <Optional> *publish_date;
@property (nonatomic,copy) NSString <Optional> *summary;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *trading_center;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *win_bid_amount;
@property (nonatomic,copy) NSString <Optional> *win_case_id;

@end
