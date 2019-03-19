//
//  DDSearchManageSystemListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/21.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchManageSystemListModel : JSONModel

/*
 ValidityPeriodEnd = "2018-09-15"
 authProject = "环境<font color='red'>管理</font><font color='red'>体系</font>认证";
 certNum = "02315E20578R1M-A";
 enterpriseId = "1";
 enterpriseName = "一重集团大连工程建设有限公司";
 id = "00016f385902fff5bc27c9a512b3819b";
 publishDate = "2015-10-17";
 */

@property (nonatomic, copy) NSString <Optional> *validityPeriodEnd;
@property (nonatomic, copy) NSString <Optional> *authProject;
@property (nonatomic, copy) NSString <Optional> *certNum;
@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *publishDate;

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
