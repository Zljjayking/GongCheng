//
//  DDSimpleCancelModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface DDSimpleCancelNoticeModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *cancelResult;
@property (nonatomic,copy) NSString <Optional> *cancelTime;
@property (nonatomic,copy) NSString <Optional> *objectionContent;
@property (nonatomic,copy) NSString <Optional> *objectionName;
@property (nonatomic,copy) NSString <Optional> *objectionTime;
@property (nonatomic,copy) NSString <Optional> *publishTime;
@property (nonatomic,copy) NSString <Optional> *url;

@end

@interface DDSimpleCancelModel : JSONModel

/*
 code = "91110105788953033D";
 dept = "北京市工商行政管理局朝阳分局";
 entName = "HYUNDAI工程建设(北京)有限公司"
 notice = {
 cancelResult = "简易注销结果"
 cancelTime = "简易注销结果申请时间";
 objectionContent = "异议内容";
 objectionName = "异议申请人";
 objectionTime = "异议时间";
 publishTime = "公告时间";
 url = "承诺书链接";
 };
 */

@property (nonatomic,copy) NSString <Optional> *code;
@property (nonatomic,copy) NSString <Optional> *dept;
@property (nonatomic,copy) NSString <Optional> *entName;
@property (nonatomic,copy) DDSimpleCancelNoticeModel <Optional> *notice;


@end

NS_ASSUME_NONNULL_END
