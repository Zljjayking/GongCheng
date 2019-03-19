//
//  DDNewInviteListModel.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/9.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 enterprise_id = 186457;
 money_type = 0;
 project_manager = "吴健宇";
 publish_date = "2019-01-09";
 title = "常熟琴湖惠民医院迁扩建工程";
 trading_center = "江苏省建设工程招标网";
 type = 1;
 win_bid_amount = 0;
 win_bid_org = "常熟市新苑地建筑装饰工程有限公司";
 win_bid_text = <null>
 win_case_id = 1344616370414899;
 */
@interface DDNewInviteListModel : NSObject
@property (nonatomic,copy) NSString *enterprise_id;
@property (nonatomic,copy) NSString *money_type;
@property (nonatomic,copy) NSString *project_manager;
@property (nonatomic,copy) NSString *publish_date;//中标时间
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *trading_center;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *win_bid_amount;//中标价
@property (nonatomic,copy) NSString *win_bid_org;//中标人
@property (nonatomic,copy) NSString *win_bid_text;
@property (nonatomic,copy) NSString *win_case_id;
@property (nonatomic,copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
