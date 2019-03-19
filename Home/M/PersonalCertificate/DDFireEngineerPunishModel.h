//
//  DDFireEngineerPunishModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerPunishModel : JSONModel

/*
 fireId = 1;
 firePunish = "12"
 id = 1;
 projectRef = "32";
 punishCase = "12";
 punishTime = "2018-09-25 00:00:00";
 punishType = "213";
 unit = "12";
 */

@property (nonatomic,copy)NSString <Optional> *fireId;
@property (nonatomic,copy)NSString <Optional> *firePunish;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *projectRef;
@property (nonatomic,copy)NSString <Optional> *punishCase;
@property (nonatomic,copy)NSString <Optional> *punishTime;
@property (nonatomic,copy)NSString <Optional> *punishType;
@property (nonatomic,copy)NSString <Optional> *unit;

@end

NS_ASSUME_NONNULL_END
