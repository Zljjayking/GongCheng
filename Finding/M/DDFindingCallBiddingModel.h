//
//  DDFindingCallBiddingModel.h
//  GongChengDD
//
//  Created by xzx on 2018/11/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingCallBiddingModel : JSONModel

/*
 bid_company = "南京市第一中学";
 content = ""
 created_time = "2018-11-21 14:05:52";
 created_user_id = 0;
 data_state = 1;
 deleted = 0;
 host_url = "http://ggzy.njzwfw.gov.cn/njweb/fjsz/068001/068001001/20181031/3a63cf96-7362-4ddf-9e45-0da50b89580b.html";
 invite_amount = 375200;
 invite_id = 1344616370331190;
 invite_text = "";
 money_type = 0;
 name = "建筑工程";
 project_type = 410001;
 publish_date = "2018-11-21";
 region_id = 320100;
 send_status = 0;
 spider_type = 1;
 title = "南京市第一中学劳技楼加固改造工程";
 trading_center = "南京市公共资源交易中心  ";
 updated_time = "2018-11-22 09:45:04";
 updated_user_id = 2;
 */

@property (nonatomic,copy)NSString <Optional> *bid_company;
@property (nonatomic,copy)NSString <Optional> *content;
@property (nonatomic,copy)NSString <Optional> *created_time;
@property (nonatomic,copy)NSString <Optional> *created_user_id;
@property (nonatomic,copy)NSString <Optional> *data_state;
@property (nonatomic,copy)NSString <Optional> *deleted;
@property (nonatomic,copy)NSString <Optional> *host_url;
@property (nonatomic,copy)NSString <Optional> *invite_amount;
@property (nonatomic,copy)NSString <Optional> *invite_id;
@property (nonatomic,copy)NSString <Optional> *invite_text;
@property (nonatomic,copy)NSString <Optional> *money_type;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *project_type;
@property (nonatomic,copy)NSString <Optional> *publish_date;
@property (nonatomic,copy)NSString <Optional> *region_id;
@property (nonatomic,copy)NSString <Optional> *send_status;
@property (nonatomic,copy)NSString <Optional> *spider_type;
@property (nonatomic,copy)NSString <Optional> *title;
@property (nonatomic,copy)NSString <Optional> *trading_center;
@property (nonatomic,copy)NSString <Optional> *updated_time;
@property (nonatomic,copy)NSString <Optional> *updated_user_id;

@end

NS_ASSUME_NONNULL_END
