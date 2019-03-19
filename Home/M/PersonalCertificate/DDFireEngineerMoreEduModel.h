//
//  DDFireEngineerMoreEduModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDFireEngineerMoreEduModel : JSONModel

/*
 endTime = "2018-09-25 00:00:00";
 fireId = 1;
 id = 1;
 remark = "1"
 year = "1";
 */

@property (nonatomic,copy)NSString <Optional> *endTime;
@property (nonatomic,copy)NSString <Optional> *fireId;
@property (nonatomic,copy)NSString <Optional> *id;
@property (nonatomic,copy)NSString <Optional> *remark;
@property (nonatomic,copy)NSString <Optional> *year;

@end

NS_ASSUME_NONNULL_END
