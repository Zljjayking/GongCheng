//
//  DDSearchAdminPunishListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/1.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchAdminPunishListModel : JSONModel

/*
 bulletin_department = "我乱说的";
 enterprise_id = 1229292237947136;
 enterprise_name = "<font color='red'>江苏</font>康森迪信息科技有限公司";
 punish_id = 2;
 punish_name = "还是假的";
 punish_time = "2018-05-24"
 */

@property (nonatomic, copy) NSString <Optional> *bulletin_department;
@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *punish_id;
@property (nonatomic, copy) NSString <Optional> *punish_name;
@property (nonatomic, copy) NSString <Optional> *punish_time;

@property (nonatomic, copy) NSAttributedString <Optional> *punishTitleStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr;

@end
