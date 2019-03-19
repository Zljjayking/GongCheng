//
//  DDTaxCreditModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/27.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTaxCreditModel : JSONModel

/*
 createdTime = "2018-10-23 22:03:43";
 enterpriseId = 1375829334685313;
 enterpriseName = "淮北市大明混凝土有限公司";
 id = 31207;
 originalHref = "http://hd.chinatax.gov.cn/fagui/action/InitCredit.do";
 score = "A";
 taxpayer = "淮北市大明混凝土有限公司";
 taxpayerNum = "340621675899843";
 updatedTime = "2018-10-27 10:59:10"
 year = 2017;
 */

@property (nonatomic, copy) NSString <Optional> *createdTime;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *originalHref;
@property (nonatomic, copy) NSString <Optional> *score;
@property (nonatomic, copy) NSString <Optional> *taxpayer;
@property (nonatomic, copy) NSString <Optional> *taxpayerNum;
@property (nonatomic, copy) NSString <Optional> *updatedTime;
@property (nonatomic, copy) NSString <Optional> *year;

@end

NS_ASSUME_NONNULL_END
