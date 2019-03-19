//
//  DDPeopleDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/5/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DDRolesModel<NSObject>
@end

@interface DDRolesModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *code;
@property (nonatomic,copy)NSString <Optional> *role;
@end

/*
 accident_count = 0;
 address = <null>;
 cert_count = 1;
 cert_type_source = "建筑工程,市政公用工程,地基基础工程,防水防腐保温工程,建筑装修装饰工程,特种工程(结构补强),钢结构工程";
 enterprise_id = 1452522832003328;
 enterprise_name = "南京金湖建筑安装工程有限公司"
 legal_representative = <null>;
 name = "贺敏";
 project_count = 0;
 punish_count = 0;
 reward_count = 0;
 roles = [
 {
 code = 4
 role = "安全员";
 }
 ];
 */

@interface DDPeopleDetailModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *accident_count;
@property (nonatomic,copy) NSString <Optional> *address;
@property (nonatomic,copy) NSString <Optional> *cert_count;
@property (nonatomic,copy) NSString <Optional> *cert_type_source;
@property (nonatomic,copy) NSString <Optional> *enterprise_id;
@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *legal_representative;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *tel;
@property (nonatomic,copy) NSString <Optional> *claim;
@property (nonatomic,copy) NSString <Optional> *isopen;
@property (nonatomic,copy) NSString <Optional> *is_collect;
@property (nonatomic,copy) NSString <Optional> *user_id;
@property (nonatomic,copy) NSString <Optional> *project_count;
@property (nonatomic,copy) NSString <Optional> *punish_count;
@property (nonatomic,copy) NSString <Optional> *reward_count;
@property (nonatomic,copy) NSString <Optional> *staff_info_id;
@property (nonatomic,copy) NSArray <Optional,DDRolesModel> *roles;
@property (nonatomic,copy) NSString <Optional> *user_tel;

@end
