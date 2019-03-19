//
//  DDSearchBuilderAndManagerListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/31.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDRolesListModel<NSObject>
@end

@interface DDRolesListModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *code;
@property (nonatomic,copy)NSString <Optional> *role;
@end

@interface DDSearchBuilderAndManagerListModel : JSONModel

/*
 accident = <null>;
 allcert = 1;
 enterprise_id = 84729;
 enterprise_name = "安华智能股份公司";
 name = "王军"
 project = 0;
 punish = <null>;
 reward = <null>;
 roles = [
 {
 code = 3
 role = "二级建造师";
 }
 ];
 staff_info_id = 821;
 */

@property (nonatomic, copy) NSString <Optional> *accident;
@property (nonatomic, copy) NSString <Optional> *allcert;
@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *project;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *claim;//0是未认领，1是认领
@property (nonatomic, copy) NSString <Optional> *isopen;
@property (nonatomic, copy) NSString <Optional> *punish;
@property (nonatomic, copy) NSString <Optional> *reward;
@property (nonatomic, copy) NSString <Optional> *staff_info_id;
@property (nonatomic,copy)  NSArray <Optional,DDRolesListModel> *roles;

@end
