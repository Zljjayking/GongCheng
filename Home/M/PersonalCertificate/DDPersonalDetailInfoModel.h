//
//  DDPersonalDetailInfoModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/29.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPersonalDetailInfoModel : JSONModel

/*
 certNo = "124100823";
 certificateId = 647967;
 claim = 0;
 name = "赵澍"
 registeredNo = "4101615-003";
 userId = <null>;
 validityPeriodEnd = "2018-12-31";
 */

@property (nonatomic,copy)NSString <Optional> *certNo;
@property (nonatomic,copy)NSString <Optional> *certificateId;
@property (nonatomic,copy)NSString <Optional> *claim;
@property (nonatomic,copy)NSString <Optional> *hasBCertificate;
@property (nonatomic,copy)NSString <Optional> *specialitySource;
@property (nonatomic,copy)NSString <Optional> *name;
@property (nonatomic,copy)NSString <Optional> *registeredNo;
@property (nonatomic,copy)NSString <Optional> *userId;
@property (nonatomic,copy)NSString <Optional> *validityPeriodEnd;
@property (nonatomic,copy)NSString <Optional> *achievementNum;
@property (nonatomic,copy)NSString <Optional> *changeNum;
@property (nonatomic,copy)NSString <Optional> *staffInfoId;
@property (nonatomic,copy)NSString <Optional> *certLevel;// 1一建 2二建
@property (nonatomic,copy)NSString <Optional> *formal;//1正式  0临时
@end

NS_ASSUME_NONNULL_END
