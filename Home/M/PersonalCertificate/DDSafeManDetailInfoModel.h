//
//  DDSafeManDetailInfoModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/9.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSafeManDetailInfoModel : JSONModel

/*
 certNo = "苏建安C(2013)1300326";
 certStateSource = "注销";
 certType = "C";
 certificateId = 685699;
 claim = 0;
 name = "陈亮亮"
 userId = <null>;
 validityPeriodEnd = "2016-04-24";
 */

@property (nonatomic,copy)NSString <Optional> *certNo;
@property (nonatomic,copy)NSString <Optional> *certStateSource;
@property (nonatomic,copy)NSString <Optional> *certType;
@property (nonatomic,copy)NSString <Optional> *certificateId;
@property (nonatomic,copy)NSString <Optional> *claim;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *validityPeriodEnd;
@property (nonatomic,copy)NSString <Optional> *staffInfoId;
@end

NS_ASSUME_NONNULL_END
