//
//  DDDAbideContractModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"
/*
 certificationLevel = "123";
 createdTime = "2018-09-19 10:11:54";
 enterpriseId = 1;
 enterpriseName = "cdsfsadfs";
 id = 2;
 publishDate = "2018-09-19 00:00:00";
 publisher = "123";
 regionId = 320000;
 title = "313";
 updatedTime = "2018-09-19 10:11:57"
 */
NS_ASSUME_NONNULL_BEGIN

@interface DDDAbideContractModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certificationLevel;
@property (nonatomic,copy) NSString<Optional> *createdTime;
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *publishDate;
@property (nonatomic,copy) NSString<Optional> *publisher;
@property (nonatomic,copy) NSString<Optional> *regionId;
@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *updatedTime;
@end

NS_ASSUME_NONNULL_END
