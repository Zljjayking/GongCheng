//
//  DDBrandModel.h
//  GongChengDD
//
//  Created by csq on 2018/9/20.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 application_date = "2013-01-28";
 brand_img = "http://tm-image.qichacha.com/84a071d9bbb92c2067a7a5a8be4b42c2.jpg";
 brand_name = "青岛中建联合建设工程有限公司 QINGDAO ZHONGJIAN COMBINATION CONST"
 brand_status = "商标无效";
 brand_type = "37-建筑修理";
 enterprise_id = 79516;
 enterprise_name = "青岛中建联合建设工程有限公司";
 register_id = "12112404";
 status_type = <null>;
 url_id = "7f9a9af19c74e678e77c393bb3b1a1aa";
 */

@protocol DDBrandListModel <NSObject>
@end
@interface DDBrandListModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *application_date;
@property (nonatomic,copy) NSString<Optional> *brand_img;
@property (nonatomic,copy) NSString<Optional> *brand_name;
@property (nonatomic,copy) NSString<Optional> *brand_status;
@property (nonatomic,copy) NSString<Optional> *brand_type;
@property (nonatomic,copy) NSString<Optional> *enterprise_id;
@property (nonatomic,copy) NSString<Optional> *enterprise_name;
@property (nonatomic,copy) NSString<Optional> *register_id;
@property (nonatomic,copy) NSString<Optional> *status_type;
@property (nonatomic,copy) NSString<Optional> *url_id;
@end

@interface DDBrandModel : JSONModel
@property (nonatomic,copy) NSArray<Optional,DDBrandListModel> *list;
@property (nonatomic,copy) NSString<Optional> *totalCount;
@end

NS_ASSUME_NONNULL_END
