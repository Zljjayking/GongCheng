//
//  DDSearchCreditScoreListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchCreditScoreListModel : JSONModel

/*
 createdTime = <null>;
 creditItem = "建筑工程2、建筑工程21";
 enterpriseId = 1;
 enterpriseName = "一重集团<font color='red'>大连</font>工程建设有限公司";
 id = <null>;
 regionId = 210213;
 score = "97.69";
 scoreCity = <null>;
 scoreDate = <null>;
 updatedTime = <null>
 */
@property (nonatomic, copy) NSString <Optional> *createdTime;
@property (nonatomic, copy) NSString <Optional> *creditItem;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *regionId;
@property (nonatomic, copy) NSString <Optional> *score;
@property (nonatomic, copy) NSString <Optional> *scoreCity;
@property (nonatomic, copy) NSString <Optional> *scoreDate;
@property (nonatomic, copy) NSString <Optional> *updatedTime;

@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
