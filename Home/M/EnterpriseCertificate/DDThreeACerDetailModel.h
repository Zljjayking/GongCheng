//
//  DDThreeACerDetailModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 certTypeSource = "1";
 createdTime = "2018-09-19 09:42:51";
 enclosure = "123.pdf";
 enclosureUrl = "http://gcdd.koncendy.com/f/f/image/2022229934605312"
 enterpriseId = 1;
 enterpriseName = "测试";
 id = 1;
 level = "AAA";
 noticeDate = "2018-09-19 00:00:00";
 ratingOutlook = "稳定";
 type = "初级评级";
 unitName = <null>;
 updatedTime = "2018-09-19 09:48:21";
 validityPeriodEnd = "2018-09-19 00:00:00";
 */
@interface DDThreeACerDetailModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *certTypeSource;
@property (nonatomic,copy) NSString<Optional> *createdTime;
@property (nonatomic,copy) NSString<Optional> *enclosure;//判断是pdf还是图片
@property (nonatomic,copy) NSString<Optional> *enclosureUrl;//下载地址
@property (nonatomic,copy) NSString<Optional> *enterpriseId;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *level;
@property (nonatomic,copy) NSString<Optional> *noticeDate;//公告日期
@property (nonatomic,copy) NSString<Optional> *ratingOutlook;//评级展望
@property (nonatomic,copy) NSString<Optional> *type;//评级级别
@property (nonatomic,copy) NSString<Optional> *unitName;
@property (nonatomic,copy) NSString<Optional> *updatedTime;
@property (nonatomic,copy) NSString<Optional> *validityPeriodEnd;//"有效期
@end

NS_ASSUME_NONNULL_END
