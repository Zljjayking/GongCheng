//
//  DDSearchCourtNoticeListModel.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DDSearchCourtNoticeListModel : JSONModel

/*
 enterprise_id = 1229292237947136;
 enterprise_name = "江苏康森迪信息科技有限<font color='red'>公司</font>";
 notice_create_date = "2018-05-29";
 notice_id = 2
 notice_publisher = "最高人民法院";
 notice_title = "标题2";
 notice_type = "裁判文书";
 */

@property (nonatomic, copy) NSString <Optional> *enterprise_id;
@property (nonatomic, copy) NSString <Optional> *enterprise_name;
@property (nonatomic, copy) NSString <Optional> *notice_create_date;
@property (nonatomic, copy) NSString <Optional> *notice_id;
@property (nonatomic, copy) NSString <Optional> *notice_publisher;
//@property (nonatomic, copy) NSString <Optional> *notice_title;
@property (nonatomic, copy) NSString <Optional> *notice_type;
@property (nonatomic, copy) NSString <Optional> *notice_publish_date;

@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr;
@property (nonatomic, copy) NSAttributedString <Optional> *enterpriseNameStr2;

@end
