//
//  DDTaxIllegalModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTaxIllegalModel : JSONModel

/*
 department = "-";
 illegalId = 10
 publishTime = <null>;
 type = "偷税";
 */

@property (nonatomic,copy) NSString <Optional> *department;
@property (nonatomic,copy) NSString <Optional> *illegalId;
@property (nonatomic,copy) NSString <Optional> *publishTime;
@property (nonatomic,copy) NSString <Optional> *type;

@end

NS_ASSUME_NONNULL_END
