//
//  DDGainBiddingDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/12.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDGainBiddingDetailModel : JSONModel

/*
 amount = 666400;
 host_url = "http://ggzy.njzwfw.gov.cn/njweb/fjsz/068003/068003003/20170710/b65659c2-6c4c-40f3-b154-75de4ca267ec.html";
 image = "https://bid1001.oss-cn-hangzhou.aliyuncs.com/b9cb38ebf238e76d5266affa2e16a5fa.png";
 is_collect = 0;
 money_type = 0;
 projectTypeName = <null>;
 project_manager = "周兴贵";
 project_type = 0
 publish_date = "2017-07-10";
 title = "金叶幼儿园园舍维修改造工程";
 type = 1;
 win_bid_text = <null>;
 win_case_id = 1721423;
 */

@property (nonatomic,copy) NSString <Optional> *amount;//中标金额数值
@property (nonatomic,copy) NSString <Optional> *host_url;
@property (nonatomic,copy) NSString <Optional> *image;
@property (nonatomic,copy) NSString <Optional> *is_collect;
@property (nonatomic,copy) NSString <Optional> *project_manager;
@property (nonatomic,copy) NSString <Optional> *publish_date;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *win_case_id;
@property (nonatomic,copy) NSString <Optional> *type;//1 2项目公示公告 34PPP公示公告
@property (nonatomic,copy) NSString <Optional> *money_type;//0表示中标金额是数值类型； 1表示中标金额是文本
@property (nonatomic, copy) NSString <Optional> *win_bid_text;//中标金额文本


@end
