//
//  DDSuperVisionReportListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSuperVisionReportListModel : JSONModel

/*
 bidNum = 0;
 regionName = "全国"
 */

@property (nonatomic,copy)NSString <Optional> *bidNum;
@property (nonatomic,copy)NSString <Optional> *bidInviteNum;
@property (nonatomic,copy)NSString <Optional> *staffNum;
@property (nonatomic,copy)NSString <Optional> *regionName;
@property (nonatomic,copy)NSString <Optional> *regionId;

@end

NS_ASSUME_NONNULL_END
