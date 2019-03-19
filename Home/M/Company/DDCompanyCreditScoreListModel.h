//
//  DDCompanyCreditScoreListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCompanyCreditScoreListModel : JSONModel

    /*
     createdTime = "2018-10-10 17:24:15";
     creditItem = "房建类";
     enterpriseId = 98097;
     enterpriseName = "南京龙腾建设有限公司";
     id = 23495;
     regionId = 320115;
     score = "79.1";
     scoreCity = "宿迁";
     scoreDate = "2018-08-01 00:00:00";
     scoreDateType = 1;
     updatedTime = "2018-10-11 09:49:24"
     */
@property (nonatomic,copy) NSString <Optional> *createdTime;
@property (nonatomic,copy) NSString <Optional> *creditItem;
@property (nonatomic,copy) NSString <Optional> *enterpriseId;
@property (nonatomic,copy) NSString <Optional> *enterpriseName;
@property (nonatomic,copy) NSString <Optional> *id;
@property (nonatomic,copy) NSString <Optional> *regionId;
@property (nonatomic,copy) NSString <Optional> *score;
@property (nonatomic,copy) NSString <Optional> *scoreCity;
@property (nonatomic,copy) NSString <Optional> *updatedTime;
@property (nonatomic,copy) NSString <Optional> *scoreDate;//评分时间
@property (nonatomic,copy) NSString <Optional> *scoreDateType;//评分时间类型  1年月日   2年月 3不显示
@property (nonatomic,copy) NSString <Optional> *department;//评分机构
    
@end

NS_ASSUME_NONNULL_END
