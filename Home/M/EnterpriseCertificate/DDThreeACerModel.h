//
//  DDThreeACerModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"
/*
 certTypeSource = "1";
 createdTime = "2018-09-19 09:42:51";
 enclosure = "www.baidu.com";
 enterpriseId = 1;
 enterpriseName = "测试";
 id = 1;
 level = "AAA";
 noticeDate = "2018-09-19 00:00:00"
 ratingOutlook = "稳定";
 type = "初级评级";
 updatedTime = "2018-09-19 09:48:21";
 validityPeriodEnd = "2018-09-19 00:00:00";
 */
NS_ASSUME_NONNULL_BEGIN

@protocol DDThreeACerListModel <NSObject>
@end
@interface DDThreeACerListModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certTypeSource;
@property (nonatomic,copy) NSString<Optional> *createdTime;
@property (nonatomic,copy) NSString<Optional> *enclosure;
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *level;
@property (nonatomic,copy) NSString<Optional> *noticeDate;
@property (nonatomic,copy) NSString<Optional> *ratingOutlook;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *updatedTime;
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;
@end

@interface DDThreeACerModel : JSONModel
@property (nonatomic,copy) NSArray<Optional,DDThreeACerListModel> *list;
@property (nonatomic,copy) NSString<Optional> *totalCount;
@end

NS_ASSUME_NONNULL_END
