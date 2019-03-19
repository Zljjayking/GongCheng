//
//  DDExaminationDynamicListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDExaminationDynamicListModel : JSONModel

/*
 createdTime = "1900-01-01 00:00:00";
 createdUserId = 0;
 deleted = 0;
 examCertType = "110000";
 examCertType2nd = "  ";
 noticeId = 1764212769718856;
 noticeMonth = 9;
 noticeYear = 2018;
 publishDate = "2018-07-11 00:00:00"
 regionid = 320100;
 title = "南京市关于2018年度一级建造师资格考试考务工作有关事项的通知";
 updatedTime = "1900-01-01 00:00:00";
 updatedUserId = 0;
 urlSource = "http://www.njrsks.net/news/detials.aspx?uid=1612";
 websiteSource = <null>;
 */

@property (nonatomic,copy) NSString <Optional> *createdTime;
@property (nonatomic,copy) NSString <Optional> *createdUserId;
@property (nonatomic,copy) NSString <Optional> *deleted;
@property (nonatomic,copy) NSString <Optional> *examCertType;
@property (nonatomic,copy) NSString <Optional> *examCertType2nd;
@property (nonatomic,copy) NSString <Optional> *noticeId;
@property (nonatomic,copy) NSString <Optional> *noticeMonth;
@property (nonatomic,copy) NSString <Optional> *noticeYear;
@property (nonatomic,copy) NSString <Optional> *publishDate;
@property (nonatomic,copy) NSString <Optional> *regionid;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *updatedTime;
@property (nonatomic,copy) NSString <Optional> *updatedUserId;
@property (nonatomic,copy) NSString <Optional> *urlSource;
@property (nonatomic,copy) NSString <Optional> *websiteSource;

@end

NS_ASSUME_NONNULL_END
