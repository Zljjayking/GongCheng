//
//  DDPeopleBelongProjectModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPeopleBelongProjectModel : JSONModel

/*
 enterprise_name = "江苏康森迪信息科技有限公司";
 project_manager = "杨建安";
 publish_date = "2018-01-11";
 summary = "（栖霞区）教师发展中心改造提升工程施工"
 trading_center = "南京市公共资源交易中心";
 win_bid_amount = 5503350.87;
 win_case_id = 1358856394080768;
 */

@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *project_manager;
@property (nonatomic,copy) NSString <Optional> *publish_date;
@property (nonatomic,copy) NSString <Optional> *summary;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *level;//1:建造师的 2：其他的  3：消防的
@property (nonatomic,copy) NSString <Optional> *trading_center;
@property (nonatomic,copy) NSString <Optional> *win_bid_amount;
@property (nonatomic,copy) NSString <Optional> *win_case_id;
@property (nonatomic,copy) NSString <Optional> *project_id;
@property (nonatomic,copy) NSString <Optional> *address;
@property (nonatomic,copy) NSString <Optional> *duty;

@property (nonatomic,copy) NSString <Optional> *money_type;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *win_bid_text;
@end
