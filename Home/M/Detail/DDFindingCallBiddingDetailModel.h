//
//  DDFindingCallBiddingDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/11/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFindingCallBiddingDetailModel : JSONModel

/*
 bid_company = "南京江北新区中心区发展有限公司";
 content = ""
 created_time = "2018-11-21 11:05:51";
 
 created_user_id = 0;
 data_state = 1;
 deleted = 0;
 host_url = "http://ggzy.njzwfw.gov.cn/njweb/fjsz/068001/068001001/20181031/637b0fc3-811b-42f3-bf28-185414348315.html";
 invite_amount = 23150000;
 invite_id = 1344616370331189;
 invite_text = "";
 money_type = 0;
 name = "建筑工程";
 project_type = 410001;
 publish_date = "2018-11-21";
 region_id = 320100;
 send_status = 0;
 spider_type = 1;
 title = "横江大道（纬三路-城南河路段）快速化改造工程";
 trading_center = "南京市公共资源交易中心  ";
 updated_time = "2018-11-22 09:45:12";
 updated_user_id = 2;
 */

@property (nonatomic,copy) NSString <Optional> *bid_company;
@property (nonatomic,copy) NSString <Optional> *content;
@property (nonatomic,copy) NSString <Optional> *created_time;
@property (nonatomic,copy) NSString <Optional> *created_user_id;
@property (nonatomic,copy) NSString <Optional> *data_state;
@property (nonatomic,copy) NSString <Optional> *deleted;
@property (nonatomic,copy) NSString <Optional> *host_url;
@property (nonatomic,copy) NSString <Optional> *invite_amount;
@property (nonatomic,copy) NSString <Optional> *invite_id;
@property (nonatomic,copy) NSString <Optional> *invite_text;
@property (nonatomic,copy) NSString <Optional> *money_type;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *project_type;
@property (nonatomic,copy) NSString <Optional> *publish_date;
@property (nonatomic,copy) NSString <Optional> *region_id;
@property (nonatomic,copy) NSString <Optional> *send_status;
@property (nonatomic,copy) NSString <Optional> *spider_type;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *trading_center;
@property (nonatomic,copy) NSString <Optional> *updated_time;
@property (nonatomic,copy) NSString <Optional> *updated_user_id;

@end

NS_ASSUME_NONNULL_END
