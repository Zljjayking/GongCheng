//
//  DDPeopleBelongPunishModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/28.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDPeopleBelongPunishModel : JSONModel

/*
 bulletin_department = "上海市宝山区城市管理行政执法局";
 project_ref = "";
 punish_case = "";
 punish_id = 1111123456958433;
 punish_name = "区城管执法局行政处罚案件信息公开20161103";
 punish_time = "2016-11-03";
 punish_type = "";
 type = 1
 */

@property (nonatomic,copy) NSString <Optional> *bulletin_department;
@property (nonatomic,copy) NSString <Optional> *project_ref;
@property (nonatomic,copy) NSString <Optional> *punish_case;
@property (nonatomic,copy) NSString <Optional> *punish_id;
@property (nonatomic,copy) NSString <Optional> *punish_name;
@property (nonatomic,copy) NSString <Optional> *punish_time;
@property (nonatomic,copy) NSString <Optional> *punish_type;
@property (nonatomic,copy) NSString <Optional> *type;

@end
