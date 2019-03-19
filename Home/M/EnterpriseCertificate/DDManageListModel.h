//
//  DDManageListModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/19.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
authProject = "中国职业健康安全管理体系认证";
certEndDate = "2019-11-03";
certNum = "03416S20679R0M";
postCertDate = "2016-11-04"
type = "310001";
urlId = "00001804c21f60df8aead68684dbb3d4";
 */
@interface DDManageListModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *authProject;
@property (nonatomic,copy) NSString<Optional> *certEndDate;
@property (nonatomic,copy) NSString<Optional> *certNum;
@property (nonatomic,copy) NSString<Optional> *postCertDate;
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *urlId;
@end

NS_ASSUME_NONNULL_END
