//
//  DDSearchRewardGloryListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchRewardGloryListModel : JSONModel

/*
 enterprise_id = 1229292237947136
 enterprise_name = "<font color='red'>江苏</font>康森迪信息科技有限公司";
 executor_defendant = "电视台";
 reward_explain = "《非自然死亡》";
 reward_id = 3;
 reward_issue_time = "2018-02-23";
 reward_type = "第96届日剧学院赏最佳女主角";
 staff_name = "石原里美";
 */

@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *executor_defendant;
@property (nonatomic, copy) NSString <Optional> *reward_explain;
@property (nonatomic, copy) NSString <Optional> *reward_id;
@property (nonatomic, copy) NSString <Optional> *reward_issue_time;
@property (nonatomic, copy) NSString <Optional> *reward_type;
@property (nonatomic, copy) NSString <Optional> *reward_group;
@property (nonatomic, copy) NSString <Optional> *staff_name;


@property (nonatomic, copy) NSAttributedString <Optional> *titleNameStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr;

@end
