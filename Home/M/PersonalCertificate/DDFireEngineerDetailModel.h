//
//  DDFireEngineerDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerDetailModel : JSONModel

/*
 address = "12313";
 certLevel = "一级";
 entId = 1
 entName = "一重集团大连工程建设有限公司";
 id = 1;
 registeredNo = "12313131";
 staffId = 827896;
 staffName = "邱鹏";
 unit = "一重集团大连工程建设有限公司";
 validityPeriodEnd = "2018-09-25 00:00:00";
 validityPeriodStart = "2018-09-25 00:00:00";
 */

@property (nonatomic,copy)NSString <Optional> *address;
@property (nonatomic,copy)NSString <Optional> *certLevel;
@property (nonatomic,copy)NSString <Optional> *entId;
@property (nonatomic,copy)NSString <Optional> *entName;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *claim;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *registeredNo;
@property (nonatomic,copy)NSString <Optional> *staffId;
@property (nonatomic,copy)NSString <Optional> *staffName;
@property (nonatomic,copy)NSString <Optional> *unit;
@property (nonatomic,copy)NSString <Optional> *validityPeriodEnd;
@property (nonatomic,copy)NSString <Optional> *validityPeriodStart;

@end

NS_ASSUME_NONNULL_END
