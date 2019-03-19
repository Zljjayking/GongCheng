//
//  DDArchitectModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDArchitectModel : JSONModel

/*
 certId = 3;
 cert_no = "1321";
 claim = 0;
 enterprise_name = "一重集团大连工程建设有限公司";
 name = "邱鹏"
 project_count = 1;
 registered_no = "2313131321";
 staff_info_id = 827896;
 user_id = 0;
 validity_period_end = "2018-09-01";
 */
@property (nonatomic,copy)NSString <Optional> *certId;
@property (nonatomic,copy)NSString <Optional> *cert_no;
@property (nonatomic,copy)NSString <Optional> *claim;
@property (nonatomic,copy)NSString <Optional> *enterprise_name;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *project_count;
@property (nonatomic,copy)NSString <Optional> *registered_no;
@property (nonatomic,copy)NSString <Optional> *staff_info_id;
@property (nonatomic,copy)NSString <Optional> *user_id;
@property (nonatomic,copy)NSString <Optional> *validity_period_end;

@end

NS_ASSUME_NONNULL_END
