//
//  DDOweTaxNoticeModel.h
//  GongChengDD
//
//  Created by xzx on 2018/10/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOweTaxNoticeModel : JSONModel

/*
 balance = "100万元";
 department = "青岛市地方税务局市北分局";
 noticeId = 1;
 publishTime = "2018-10-18";
 taxpayerNum = "3702000002515775BY"
 type = "企业所得税";
 */

@property (nonatomic,copy) NSString <Optional> *balance;
@property (nonatomic,copy) NSString <Optional> *department;
@property (nonatomic,copy) NSString <Optional> *noticeId;
@property (nonatomic,copy) NSString <Optional> *publishTime;
@property (nonatomic,copy) NSString <Optional> *taxpayerNum;
@property (nonatomic,copy) NSString <Optional> *type;

@end

NS_ASSUME_NONNULL_END
