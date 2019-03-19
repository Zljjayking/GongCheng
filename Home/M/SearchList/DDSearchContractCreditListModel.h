//
//  DDSearchContractCreditListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDSearchContractCreditListModel : JSONModel

/*
 enterpriseId = "123"
 enterpriseName = "
 
 上海勋华建筑工程安装<font color='red'>有限公司</font>";
 id = "1";
 publishDate = "2018-09-19";
 publisher = "南京市工商行政管理局";
 tccTitle = "被评为2016年度南京市市级“守合同重信用”企业";
 */

@property (nonatomic, copy) NSString <Optional> *enterpriseId;
@property (nonatomic, copy) NSString <Optional> *enterpriseName;
@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *publishDate;
@property (nonatomic, copy) NSString <Optional> *publisher;
@property (nonatomic, copy) NSString <Optional> *tccTitle;

@property (nonatomic, copy) NSAttributedString <Optional> *titleAttrStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameAttrStr;

@end

NS_ASSUME_NONNULL_END
