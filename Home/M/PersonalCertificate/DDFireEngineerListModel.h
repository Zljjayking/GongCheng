//
//  DDFireEngineerListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerListModel : JSONModel

/*
 certId = 1;
 cert_level = "一级";
 claim = 1;
 ent_name = "一重集团大连工程建设有限公司"
 id = 1;
 registered_no = "12313131";
 staff_id = 827896;
 staff_name = "邱鹏";
 user_id = 1483497843459050;
 validity_period_end = "2018-09-25";
 */

@property (nonatomic,copy)NSString <Optional> *certId;
@property (nonatomic,copy)NSString <Optional> *cert_level;
@property (nonatomic,copy)NSString <Optional> *claim;
@property (nonatomic,copy)NSString <Optional> *ent_name;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *registered_no;
@property (nonatomic,copy)NSString <Optional> *staff_id;
@property (nonatomic,copy)NSString <Optional> *staff_name;
@property (nonatomic,copy)NSString <Optional> *validity_period_end;
@property (nonatomic,copy)NSString <Optional> *user_id;

@end

NS_ASSUME_NONNULL_END
