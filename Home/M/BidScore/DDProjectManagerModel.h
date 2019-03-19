//
//  DDProjectManagerModel.h
//  GongChengDD
//
//  Created by csq on 2018/5/30.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 abc_cert_count = 1;
 builder_cert_count = 0
 enterprise_name = "江苏康森迪信息科技有限公司";
 project_count = 5;
 project_manager = "杨建安";
 punish_count = 0;
 reward_count = 0;
 staff_info_id = 1452523223909632;
*/
@interface DDProjectManagerModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *cert_count;//证书数量
@property (nonatomic, copy) NSString <Optional> *accident_count;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *project_count;
@property (nonatomic, copy) NSString <Optional> *project_manager;
@property (nonatomic, copy) NSString <Optional> *punish_count;
@property (nonatomic, copy) NSString <Optional> *reward_count;
@property (nonatomic, copy) NSString <Optional> *staff_info_id;
@end
