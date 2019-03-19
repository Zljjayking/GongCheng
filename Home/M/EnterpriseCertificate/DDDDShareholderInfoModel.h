//
//  DDDDShareholderInfoModel.h
//  GongChengDD
//
//  Created by csq on 2018/10/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"
/*
 enterpriseId = <null>;
 holderName = "张三";
 holderType = "法人股东"
 id = <null>;
 paidDate = "2018-10-10";
 paidPercent = "60";
 shareAmount = "600万元";
 */
NS_ASSUME_NONNULL_BEGIN

@interface DDDDShareholderInfoModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *holderName;
@property (nonatomic,copy) NSString<Optional> *holderType;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *paidDate;
@property (nonatomic,copy) NSString<Optional> *paidPercent;
@property (nonatomic,copy) NSString<Optional> *shareAmount;
@end

NS_ASSUME_NONNULL_END
