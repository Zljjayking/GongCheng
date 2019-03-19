//
//  DDWinTheBiddModel.h
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 enterprise_id = 98097;
 money_type = 0;
 project_manager = "耿军";
 publish_date = "2015-05-14";
 staff_info_id = 3681248;
 title = "江苏泉硕汽车空调有限公司新建厂房1#、2#";
 trading_center = "";
 type = 1;
 win_bid_amount = 11399226.69;
 win_bid_org = "南京龙腾建设有限公司"
 win_bid_text = <null>;
 win_case_id = 1932780;
 */
@interface DDWinTheBiddModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *project_manager;
@property (nonatomic, copy) NSString <Optional> *publish_date;
@property (nonatomic, copy) NSString <Optional> *staff_info_id;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *trading_center;
@property (nonatomic, copy) NSString <Optional> *win_bid_amount;//中标金额数值
@property (nonatomic, copy) NSString <Optional> *win_bid_org;
@property (nonatomic, copy) NSString <Optional> *win_case_id;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *money_type;//0表示中标金额是数值类型； 1表示中标金额是文本
@property (nonatomic, copy) NSString <Optional> *win_bid_text;//中标金额文本

@end
