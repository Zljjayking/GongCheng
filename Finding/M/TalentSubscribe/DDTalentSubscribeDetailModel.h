//
//  DDTalentSubscribeDetailModel.h
//  GongChengDD
//
//  Created by xzx on 2018/11/25.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTalentSubscribeDetailModel : JSONModel

/*
 createdTime = "2018-11-25 10:53:55";
 createdUserId = 1379615402787072
 deleted = 0;
 monitorId = 11;
 monitorType = 1;
 projectCertType = "1,2,3";
 regionId = 110000;
 updatedTime = "2018-11-25 10:53:55";
 updatedUserId = 1379615402787072;
 userId = 1379615402787072;
 validityType = 1;
 */

@property (nonatomic,copy)NSString <Optional> *createdTime;
@property (nonatomic,copy)NSString <Optional> *createdUserId;
@property (nonatomic,copy)NSString <Optional> *deleted;
@property (nonatomic,copy)NSString <Optional> *monitorId;
@property (nonatomic,copy)NSString <Optional> *monitorType;
@property (nonatomic,copy)NSString <Optional> *projectCertType;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *regionId;
@property (nonatomic,copy)NSString <Optional> *updatedTime;
@property (nonatomic,copy)NSString <Optional> *updatedUserId;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *validityType;

@end

NS_ASSUME_NONNULL_END
