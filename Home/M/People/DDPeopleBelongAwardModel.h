//
//  DDPeopleBelongAwardModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPeopleBelongAwardModel : JSONModel

/*
 executor_defendant = "电视台";
 reward_explain = "参演喜剧电影《我的爷爷》";
 reward_id = 1;
 reward_issue_time = "2004-02-20";
 reward_type = "第28届报知映画赏新人赏"
 */

@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *executor_defendant;
@property (nonatomic,copy) NSString <Optional> *reward_explain;
@property (nonatomic,copy) NSString <Optional> *reward_id;
@property (nonatomic,copy) NSString <Optional> *reward_issue_time;
@property (nonatomic,copy) NSString <Optional> *reward_type;
@property (nonatomic,copy) NSString <Optional> *reward_group;

@end
