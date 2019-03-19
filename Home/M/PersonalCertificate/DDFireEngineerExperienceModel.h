//
//  DDFireEngineerExperienceModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerExperienceModel : JSONModel

/*
 duty = "2";
 fireId = 1;
 id = 1;
 time = "2018-09-25 00:00:00"
 title = "测试";
 */

@property (nonatomic,copy)NSString <Optional> *duty;
@property (nonatomic,copy)NSString <Optional> *fireId;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *time;
@property (nonatomic,copy)NSString <Optional> *title;

@end

NS_ASSUME_NONNULL_END
