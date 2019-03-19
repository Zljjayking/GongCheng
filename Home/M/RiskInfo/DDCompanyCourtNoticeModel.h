//
//  DDCompanyCourtNoticeModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/5.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDCompanyCourtNoticeModel : JSONModel

/*
 enterprise_name = "江苏康森迪信息科技有限公司";
 notice_create_date = "2018-05-29";
 notice_id = 1
 notice_publish_date = "2018-05-30";
 notice_publisher = "最高人民法院";
 notice_title = "标题1";
 notice_type = "民事案件";
 */

@property (nonatomic,copy) NSString <Optional> *enterprise_name;
@property (nonatomic,copy) NSString <Optional> *notice_create_date;
@property (nonatomic,copy) NSString <Optional> *notice_id;
@property (nonatomic,copy) NSString <Optional> *notice_publish_date;
@property (nonatomic,copy) NSString <Optional> *notice_publisher;
//@property (nonatomic,copy) NSString <Optional> *notice_title;
@property (nonatomic,copy) NSString <Optional> *notice_type;

@end
